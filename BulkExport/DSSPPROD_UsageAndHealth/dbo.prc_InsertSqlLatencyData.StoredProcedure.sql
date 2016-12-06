USE [DSSPPROD_UsageAndHealth]
GO
/****** Object:  StoredProcedure [dbo].[prc_InsertSqlLatencyData]    Script Date: 11/10/2016 4:16:42 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[prc_InsertSqlLatencyData]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[prc_InsertSqlLatencyData]    
        @FarmId UniqueIdentifier, @SiteSubscriptionId UniqueIdentifier, @UserLogin NVarChar(300), @CorrelationId UniqueIdentifier, @DataSource NVarChar(100), @InitialCatalog NVarChar(100), @UserID NVarChar(100), @Count Int, @StartTime DateTime, @EndTime DateTime, @Exceptions Int, @Percentile50 Int, @Percentile75 Int, @Percentile90 Int, @Percentile95 Int, @Percentile99 Int, @MaxLatency Int,         
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
        SELECT @ConfigName = ''Retention Period - SqlLatencyData''
        SELECT @RetentionPeriod = CAST(dbo.fn_GetConfigValue(@ConfigName)  as smallint)
        IF (datediff(dd, @LogTime, @UTCDate) > @RetentionPeriod OR
            datediff(hh, @LogTime, @UTCDate) < 0)
        BEGIN
            RETURN
        END
	SELECT @ConfigName = ''Max Total Bytes - SqlLatencyData''
	SELECT @MaxBytes = CAST(dbo.fn_GetConfigValue(@ConfigName) as bigint) / @RetentionPeriod
        SELECT @PartitionId = dbo.fn_GetPartitionId(@LogTime)
        exec dbo.prc_LogAndRollOverPartition ''SqlLatencyData'', @UTCDate 
		-- Silently fail if the partition is full.
		IF (dbo.fn_GetPartitionSize(''SqlLatencyData_Partition'' + CAST(@PartitionId as NVARCHAR(MAX))) >= @MaxBytes)
		BEGIN
			RETURN
		END
        DECLARE @SQL nvarchar(MAX), 
		        @SQLParams nvarchar(MAX)
        SELECT @SQL =
	           CAST(''INSERT INTO [dbo].[SqlLatencyData_Partition'' AS NVARCHAR(MAX)) + CAST(@PartitionId as NVARCHAR(MAX)) + CAST('']
			        (PartitionId, 
			        LogTime,
			        MachineName,
                FarmId, SiteSubscriptionId, UserLogin, CorrelationId, DataSource, InitialCatalog, UserID, Count, StartTime, EndTime, Exceptions, Percentile50, Percentile75, Percentile90, Percentile95, Percentile99, MaxLatency, 
			        RowCreatedTime) 
		        SELECT 
			        @PartitionId,
			        @LogTime,
			        @MachineName,
                @FarmId, @SiteSubscriptionId, @UserLogin, @CorrelationId, @DataSource, @InitialCatalog, @UserID, @Count, @StartTime, @EndTime, @Exceptions, @Percentile50, @Percentile75, @Percentile90, @Percentile95, @Percentile99, @MaxLatency, 
			        @UTCDate'' AS NVARCHAR(MAX))
        SELECT @SQLParams = 
		        ''@PartitionId tinyint,
		        @LogTime datetime,
		        @MachineName nvarchar(128),
                @FarmId UniqueIdentifier, @SiteSubscriptionId UniqueIdentifier, @UserLogin NVarChar(300), @CorrelationId UniqueIdentifier, @DataSource NVarChar(100), @InitialCatalog NVarChar(100), @UserID NVarChar(100), @Count Int, @StartTime DateTime, @EndTime DateTime, @Exceptions Int, @Percentile50 Int, @Percentile75 Int, @Percentile90 Int, @Percentile95 Int, @Percentile99 Int, @MaxLatency Int,         
		        @UTCDate datetime''
        exec sp_executesql
	        @SQL,
	        @SQLParams,
	        @PartitionId,
            @LogTime,
            @MachineName,
	        @FarmId, @SiteSubscriptionId, @UserLogin, @CorrelationId, @DataSource, @InitialCatalog, @UserID, @Count, @StartTime, @EndTime, @Exceptions, @Percentile50, @Percentile75, @Percentile90, @Percentile95, @Percentile99, @MaxLatency, 
            @UTCDate
    END' 
END
GO
