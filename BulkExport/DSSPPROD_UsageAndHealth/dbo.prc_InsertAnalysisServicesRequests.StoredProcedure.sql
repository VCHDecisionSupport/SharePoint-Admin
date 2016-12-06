USE [DSSPPROD_UsageAndHealth]
GO
/****** Object:  StoredProcedure [dbo].[prc_InsertAnalysisServicesRequests]    Script Date: 11/10/2016 4:16:42 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[prc_InsertAnalysisServicesRequests]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[prc_InsertAnalysisServicesRequests]    
        @FarmId UniqueIdentifier, @SiteSubscriptionId UniqueIdentifier, @UserLogin NVarChar(300), @CorrelationId UniqueIdentifier, @AnalysisServicesInstance NVarChar(256), @DatabaseId UniqueIdentifier, @ServiceApplicationId UniqueIdentifier, @UserName NVarChar(400), @ImageUrl NVarChar(2048), @SPFileID UniqueIdentifier, @SPSiteID UniqueIdentifier, @VersionLabel NVarChar(10), @DeltaElapsedTime Int, @TrivialCount Int, @TrivialElapsedMs Int, @TrivialUpperLimit Int, @QuickCount Int, @QuickElapsedMs Int, @QuickUpperLimit Int, @ExpectedCount Int, @ExpectedElapsedMs Int, @ExpectedUpperLimit Int, @LongCount Int, @LongElapsedMs Int, @LongUpperLimit Int, @ExceededCount Int, @ExceededElapsedMs Int,         
        @MachineName nvarchar(128),
        @LogTime datetime 
    AS
    BEGIN
        SET NOCOUNT ON
        DECLARE @PartitionId tinyint,
                @UTCDate datetime,
                @ConfigName nvarchar(255),
                @RetentionPeriod smallint,
		@MaxBytes bigint
        SELECT @UTCDate = getutcdate()
        -- We probably want to discard anything older than retention policy
        -- and messages from the future should be similarly ignored
        -- Just ignore without error
        SELECT @ConfigName = ''Retention Period - AnalysisServicesRequests''
        SELECT @RetentionPeriod = CAST(dbo.fn_GetConfigValue(@ConfigName)  as smallint)
        IF (datediff(dd, @LogTime, @UTCDate) > @RetentionPeriod OR
            datediff(hh, @LogTime, @UTCDate) < 0)
        BEGIN
            RETURN
        END
	SELECT @ConfigName = ''Max Total Bytes - AnalysisServicesRequests''
	SELECT @MaxBytes = CAST(dbo.fn_GetConfigValue(@ConfigName) as bigint) / @RetentionPeriod
        SELECT @PartitionId = dbo.fn_GetPartitionId(@LogTime)
        exec dbo.prc_LogAndRollOverPartition ''AnalysisServicesRequests'', @UTCDate 
		-- Silently fail if the partition is full.
		IF (dbo.fn_GetPartitionSize(''AnalysisServicesRequests_Partition'' + CAST(@PartitionId as NVARCHAR(MAX))) >= @MaxBytes)
		BEGIN
			RETURN
		END
        DECLARE @SQL nvarchar(MAX), 
		        @SQLParams nvarchar(MAX)
        SELECT @SQL =
	           CAST(''INSERT INTO [dbo].[AnalysisServicesRequests_Partition'' AS NVARCHAR(MAX)) + CAST(@PartitionId as NVARCHAR(MAX)) + CAST('']
			        (PartitionId, 
			        LogTime,
			        MachineName,
                FarmId, SiteSubscriptionId, UserLogin, CorrelationId, AnalysisServicesInstance, DatabaseId, ServiceApplicationId, UserName, ImageUrl, SPFileID, SPSiteID, VersionLabel, DeltaElapsedTime, TrivialCount, TrivialElapsedMs, TrivialUpperLimit, QuickCount, QuickElapsedMs, QuickUpperLimit, ExpectedCount, ExpectedElapsedMs, ExpectedUpperLimit, LongCount, LongElapsedMs, LongUpperLimit, ExceededCount, ExceededElapsedMs, 
			        RowCreatedTime) 
		        SELECT 
			        @PartitionId,
			        @LogTime,
			        @MachineName,
                @FarmId, @SiteSubscriptionId, @UserLogin, @CorrelationId, @AnalysisServicesInstance, @DatabaseId, @ServiceApplicationId, @UserName, @ImageUrl, @SPFileID, @SPSiteID, @VersionLabel, @DeltaElapsedTime, @TrivialCount, @TrivialElapsedMs, @TrivialUpperLimit, @QuickCount, @QuickElapsedMs, @QuickUpperLimit, @ExpectedCount, @ExpectedElapsedMs, @ExpectedUpperLimit, @LongCount, @LongElapsedMs, @LongUpperLimit, @ExceededCount, @ExceededElapsedMs, 
			        @UTCDate'' AS NVARCHAR(MAX))
        SELECT @SQLParams = 
		        ''@PartitionId tinyint,
		        @LogTime datetime,
		        @MachineName nvarchar(128),
                @FarmId UniqueIdentifier, @SiteSubscriptionId UniqueIdentifier, @UserLogin NVarChar(300), @CorrelationId UniqueIdentifier, @AnalysisServicesInstance NVarChar(256), @DatabaseId UniqueIdentifier, @ServiceApplicationId UniqueIdentifier, @UserName NVarChar(400), @ImageUrl NVarChar(2048), @SPFileID UniqueIdentifier, @SPSiteID UniqueIdentifier, @VersionLabel NVarChar(10), @DeltaElapsedTime Int, @TrivialCount Int, @TrivialElapsedMs Int, @TrivialUpperLimit Int, @QuickCount Int, @QuickElapsedMs Int, @QuickUpperLimit Int, @ExpectedCount Int, @ExpectedElapsedMs Int, @ExpectedUpperLimit Int, @LongCount Int, @LongElapsedMs Int, @LongUpperLimit Int, @ExceededCount Int, @ExceededElapsedMs Int,         
		        @UTCDate datetime''
        exec sp_executesql
	        @SQL,
	        @SQLParams,
	        @PartitionId,
            @LogTime,
            @MachineName,
	        @FarmId, @SiteSubscriptionId, @UserLogin, @CorrelationId, @AnalysisServicesInstance, @DatabaseId, @ServiceApplicationId, @UserName, @ImageUrl, @SPFileID, @SPSiteID, @VersionLabel, @DeltaElapsedTime, @TrivialCount, @TrivialElapsedMs, @TrivialUpperLimit, @QuickCount, @QuickElapsedMs, @QuickUpperLimit, @ExpectedCount, @ExpectedElapsedMs, @ExpectedUpperLimit, @LongCount, @LongElapsedMs, @LongUpperLimit, @ExceededCount, @ExceededElapsedMs, 
            @UTCDate
    END' 
END
GO
