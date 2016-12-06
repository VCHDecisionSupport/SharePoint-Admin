USE [DSSPPROD_UsageAndHealth]
GO
/****** Object:  StoredProcedure [dbo].[prc_InsertTimerJobUsage]    Script Date: 11/10/2016 4:16:42 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[prc_InsertTimerJobUsage]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[prc_InsertTimerJobUsage]    
        @FarmId UniqueIdentifier, @SiteSubscriptionId UniqueIdentifier, @UserLogin NVarChar(300), @CorrelationId UniqueIdentifier, @ServiceId UniqueIdentifier, @WebApplicationId UniqueIdentifier, @JobId UniqueIdentifier, @ServerId UniqueIdentifier, @Status Int, @StartTime DateTime, @EndTime DateTime, @WebApplicationName NVarChar(255), @JobTitle NVarChar(255), @RequestCount Int, @QueryCount Int, @QueryDurationSum BigInt, @ServiceCallCount SmallInt, @ServiceCallDurationSum BigInt, @Duration BigInt, @CPUMCycles BigInt, @CPUDuration BigInt, @ManagedMemoryBytes BigInt, @ManagedMemoryBytesLOH BigInt,         
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
        SELECT @ConfigName = ''Retention Period - TimerJobUsage''
        SELECT @RetentionPeriod = CAST(dbo.fn_GetConfigValue(@ConfigName)  as smallint)
        IF (datediff(dd, @LogTime, @UTCDate) > @RetentionPeriod OR
            datediff(hh, @LogTime, @UTCDate) < 0)
        BEGIN
            RETURN
        END
	SELECT @ConfigName = ''Max Total Bytes - TimerJobUsage''
	SELECT @MaxBytes = CAST(dbo.fn_GetConfigValue(@ConfigName) as bigint) / @RetentionPeriod
        SELECT @PartitionId = dbo.fn_GetPartitionId(@LogTime)
        exec dbo.prc_LogAndRollOverPartition ''TimerJobUsage'', @UTCDate 
		-- Silently fail if the partition is full.
		IF (dbo.fn_GetPartitionSize(''TimerJobUsage_Partition'' + CAST(@PartitionId as NVARCHAR(MAX))) >= @MaxBytes)
		BEGIN
			RETURN
		END
        DECLARE @SQL nvarchar(MAX), 
		        @SQLParams nvarchar(MAX)
        SELECT @SQL =
	           CAST(''INSERT INTO [dbo].[TimerJobUsage_Partition'' AS NVARCHAR(MAX)) + CAST(@PartitionId as NVARCHAR(MAX)) + CAST('']
			        (PartitionId, 
			        LogTime,
			        MachineName,
                FarmId, SiteSubscriptionId, UserLogin, CorrelationId, ServiceId, WebApplicationId, JobId, ServerId, Status, StartTime, EndTime, WebApplicationName, JobTitle, RequestCount, QueryCount, QueryDurationSum, ServiceCallCount, ServiceCallDurationSum, Duration, CPUMCycles, CPUDuration, ManagedMemoryBytes, ManagedMemoryBytesLOH, 
			        RowCreatedTime) 
		        SELECT 
			        @PartitionId,
			        @LogTime,
			        @MachineName,
                @FarmId, @SiteSubscriptionId, @UserLogin, @CorrelationId, @ServiceId, @WebApplicationId, @JobId, @ServerId, @Status, @StartTime, @EndTime, @WebApplicationName, @JobTitle, @RequestCount, @QueryCount, @QueryDurationSum, @ServiceCallCount, @ServiceCallDurationSum, @Duration, @CPUMCycles, @CPUDuration, @ManagedMemoryBytes, @ManagedMemoryBytesLOH, 
			        @UTCDate'' AS NVARCHAR(MAX))
        SELECT @SQLParams = 
		        ''@PartitionId tinyint,
		        @LogTime datetime,
		        @MachineName nvarchar(128),
                @FarmId UniqueIdentifier, @SiteSubscriptionId UniqueIdentifier, @UserLogin NVarChar(300), @CorrelationId UniqueIdentifier, @ServiceId UniqueIdentifier, @WebApplicationId UniqueIdentifier, @JobId UniqueIdentifier, @ServerId UniqueIdentifier, @Status Int, @StartTime DateTime, @EndTime DateTime, @WebApplicationName NVarChar(255), @JobTitle NVarChar(255), @RequestCount Int, @QueryCount Int, @QueryDurationSum BigInt, @ServiceCallCount SmallInt, @ServiceCallDurationSum BigInt, @Duration BigInt, @CPUMCycles BigInt, @CPUDuration BigInt, @ManagedMemoryBytes BigInt, @ManagedMemoryBytesLOH BigInt,         
		        @UTCDate datetime''
        exec sp_executesql
	        @SQL,
	        @SQLParams,
	        @PartitionId,
            @LogTime,
            @MachineName,
	        @FarmId, @SiteSubscriptionId, @UserLogin, @CorrelationId, @ServiceId, @WebApplicationId, @JobId, @ServerId, @Status, @StartTime, @EndTime, @WebApplicationName, @JobTitle, @RequestCount, @QueryCount, @QueryDurationSum, @ServiceCallCount, @ServiceCallDurationSum, @Duration, @CPUMCycles, @CPUDuration, @ManagedMemoryBytes, @ManagedMemoryBytesLOH, 
            @UTCDate
    END' 
END
GO
