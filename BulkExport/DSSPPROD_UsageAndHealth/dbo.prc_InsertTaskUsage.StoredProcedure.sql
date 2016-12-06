USE [DSSPPROD_UsageAndHealth]
GO
/****** Object:  StoredProcedure [dbo].[prc_InsertTaskUsage]    Script Date: 11/10/2016 4:16:42 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[prc_InsertTaskUsage]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[prc_InsertTaskUsage]    
        @FarmId UniqueIdentifier, @SiteSubscriptionId UniqueIdentifier, @UserLogin NVarChar(300), @CorrelationId UniqueIdentifier, @RequestCount SmallInt, @QueryCount SmallInt, @QueryDurationSum BigInt, @ServiceCallCount SmallInt, @ServiceCallDurationSum BigInt, @Duration BigInt, @Title NVarChar(128), @SqlLogicalReads BigInt, @CPUMCycles BigInt, @DistributedCacheReads BigInt, @DistributedCacheReadsDuration BigInt, @DistributedCacheReadsSize BigInt, @DistributedCacheWrites BigInt, @DistributedCacheWritesDuration BigInt, @DistributedCacheWritesSize BigInt, @DistributedCacheMisses BigInt, @DistributedCacheHits BigInt, @DistributedCacheFailures BigInt, @DistributedCachedObjectsRequested BigInt, @ManagedMemoryBytes BigInt, @ManagedMemoryBytesLOH BigInt,         
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
        SELECT @ConfigName = ''Retention Period - TaskUsage''
        SELECT @RetentionPeriod = CAST(dbo.fn_GetConfigValue(@ConfigName)  as smallint)
        IF (datediff(dd, @LogTime, @UTCDate) > @RetentionPeriod OR
            datediff(hh, @LogTime, @UTCDate) < 0)
        BEGIN
            RETURN
        END
	SELECT @ConfigName = ''Max Total Bytes - TaskUsage''
	SELECT @MaxBytes = CAST(dbo.fn_GetConfigValue(@ConfigName) as bigint) / @RetentionPeriod
        SELECT @PartitionId = dbo.fn_GetPartitionId(@LogTime)
        exec dbo.prc_LogAndRollOverPartition ''TaskUsage'', @UTCDate 
		-- Silently fail if the partition is full.
		IF (dbo.fn_GetPartitionSize(''TaskUsage_Partition'' + CAST(@PartitionId as NVARCHAR(MAX))) >= @MaxBytes)
		BEGIN
			RETURN
		END
        DECLARE @SQL nvarchar(MAX), 
		        @SQLParams nvarchar(MAX)
        SELECT @SQL =
	           CAST(''INSERT INTO [dbo].[TaskUsage_Partition'' AS NVARCHAR(MAX)) + CAST(@PartitionId as NVARCHAR(MAX)) + CAST('']
			        (PartitionId, 
			        LogTime,
			        MachineName,
                FarmId, SiteSubscriptionId, UserLogin, CorrelationId, RequestCount, QueryCount, QueryDurationSum, ServiceCallCount, ServiceCallDurationSum, Duration, Title, SqlLogicalReads, CPUMCycles, DistributedCacheReads, DistributedCacheReadsDuration, DistributedCacheReadsSize, DistributedCacheWrites, DistributedCacheWritesDuration, DistributedCacheWritesSize, DistributedCacheMisses, DistributedCacheHits, DistributedCacheFailures, DistributedCachedObjectsRequested, ManagedMemoryBytes, ManagedMemoryBytesLOH, 
			        RowCreatedTime) 
		        SELECT 
			        @PartitionId,
			        @LogTime,
			        @MachineName,
                @FarmId, @SiteSubscriptionId, @UserLogin, @CorrelationId, @RequestCount, @QueryCount, @QueryDurationSum, @ServiceCallCount, @ServiceCallDurationSum, @Duration, @Title, @SqlLogicalReads, @CPUMCycles, @DistributedCacheReads, @DistributedCacheReadsDuration, @DistributedCacheReadsSize, @DistributedCacheWrites, @DistributedCacheWritesDuration, @DistributedCacheWritesSize, @DistributedCacheMisses, @DistributedCacheHits, @DistributedCacheFailures, @DistributedCachedObjectsRequested, @ManagedMemoryBytes, @ManagedMemoryBytesLOH, 
			        @UTCDate'' AS NVARCHAR(MAX))
        SELECT @SQLParams = 
		        ''@PartitionId tinyint,
		        @LogTime datetime,
		        @MachineName nvarchar(128),
                @FarmId UniqueIdentifier, @SiteSubscriptionId UniqueIdentifier, @UserLogin NVarChar(300), @CorrelationId UniqueIdentifier, @RequestCount SmallInt, @QueryCount SmallInt, @QueryDurationSum BigInt, @ServiceCallCount SmallInt, @ServiceCallDurationSum BigInt, @Duration BigInt, @Title NVarChar(128), @SqlLogicalReads BigInt, @CPUMCycles BigInt, @DistributedCacheReads BigInt, @DistributedCacheReadsDuration BigInt, @DistributedCacheReadsSize BigInt, @DistributedCacheWrites BigInt, @DistributedCacheWritesDuration BigInt, @DistributedCacheWritesSize BigInt, @DistributedCacheMisses BigInt, @DistributedCacheHits BigInt, @DistributedCacheFailures BigInt, @DistributedCachedObjectsRequested BigInt, @ManagedMemoryBytes BigInt, @ManagedMemoryBytesLOH BigInt,         
		        @UTCDate datetime''
        exec sp_executesql
	        @SQL,
	        @SQLParams,
	        @PartitionId,
            @LogTime,
            @MachineName,
	        @FarmId, @SiteSubscriptionId, @UserLogin, @CorrelationId, @RequestCount, @QueryCount, @QueryDurationSum, @ServiceCallCount, @ServiceCallDurationSum, @Duration, @Title, @SqlLogicalReads, @CPUMCycles, @DistributedCacheReads, @DistributedCacheReadsDuration, @DistributedCacheReadsSize, @DistributedCacheWrites, @DistributedCacheWritesDuration, @DistributedCacheWritesSize, @DistributedCacheMisses, @DistributedCacheHits, @DistributedCacheFailures, @DistributedCachedObjectsRequested, @ManagedMemoryBytes, @ManagedMemoryBytesLOH, 
            @UTCDate
    END' 
END
GO
