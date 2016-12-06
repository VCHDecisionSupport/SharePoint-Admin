USE [DSSPPROD_UsageAndHealth]
GO
/****** Object:  StoredProcedure [dbo].[prc_InsertAppUsage]    Script Date: 11/10/2016 4:16:42 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[prc_InsertAppUsage]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[prc_InsertAppUsage]    
        @FarmId UniqueIdentifier, @SiteSubscriptionId UniqueIdentifier, @UserLogin NVarChar(300), @CorrelationId UniqueIdentifier, @SiteId UniqueIdentifier, @WebId UniqueIdentifier, @EventId Int, @Value NVarChar(2048), @AppId UniqueIdentifier, @AppInstanceId UniqueIdentifier, @InstallLocation NVarChar(2048),         
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
        SELECT @ConfigName = ''Retention Period - AppUsage''
        SELECT @RetentionPeriod = CAST(dbo.fn_GetConfigValue(@ConfigName)  as smallint)
        IF (datediff(dd, @LogTime, @UTCDate) > @RetentionPeriod OR
            datediff(hh, @LogTime, @UTCDate) < 0)
        BEGIN
            RETURN
        END
	SELECT @ConfigName = ''Max Total Bytes - AppUsage''
	SELECT @MaxBytes = CAST(dbo.fn_GetConfigValue(@ConfigName) as bigint) / @RetentionPeriod
        SELECT @PartitionId = dbo.fn_GetPartitionId(@LogTime)
        exec dbo.prc_LogAndRollOverPartition ''AppUsage'', @UTCDate 
		-- Silently fail if the partition is full.
		IF (dbo.fn_GetPartitionSize(''AppUsage_Partition'' + CAST(@PartitionId as NVARCHAR(MAX))) >= @MaxBytes)
		BEGIN
			RETURN
		END
        DECLARE @SQL nvarchar(MAX), 
		        @SQLParams nvarchar(MAX)
        SELECT @SQL =
	           CAST(''INSERT INTO [dbo].[AppUsage_Partition'' AS NVARCHAR(MAX)) + CAST(@PartitionId as NVARCHAR(MAX)) + CAST('']
			        (PartitionId, 
			        LogTime,
			        MachineName,
                FarmId, SiteSubscriptionId, UserLogin, CorrelationId, SiteId, WebId, EventId, Value, AppId, AppInstanceId, InstallLocation, 
			        RowCreatedTime) 
		        SELECT 
			        @PartitionId,
			        @LogTime,
			        @MachineName,
                @FarmId, @SiteSubscriptionId, @UserLogin, @CorrelationId, @SiteId, @WebId, @EventId, @Value, @AppId, @AppInstanceId, @InstallLocation, 
			        @UTCDate'' AS NVARCHAR(MAX))
        SELECT @SQLParams = 
		        ''@PartitionId tinyint,
		        @LogTime datetime,
		        @MachineName nvarchar(128),
                @FarmId UniqueIdentifier, @SiteSubscriptionId UniqueIdentifier, @UserLogin NVarChar(300), @CorrelationId UniqueIdentifier, @SiteId UniqueIdentifier, @WebId UniqueIdentifier, @EventId Int, @Value NVarChar(2048), @AppId UniqueIdentifier, @AppInstanceId UniqueIdentifier, @InstallLocation NVarChar(2048),         
		        @UTCDate datetime''
        exec sp_executesql
	        @SQL,
	        @SQLParams,
	        @PartitionId,
            @LogTime,
            @MachineName,
	        @FarmId, @SiteSubscriptionId, @UserLogin, @CorrelationId, @SiteId, @WebId, @EventId, @Value, @AppId, @AppInstanceId, @InstallLocation, 
            @UTCDate
    END' 
END
GO
