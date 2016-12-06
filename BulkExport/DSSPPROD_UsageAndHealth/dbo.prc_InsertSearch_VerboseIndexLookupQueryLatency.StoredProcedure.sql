USE [DSSPPROD_UsageAndHealth]
GO
/****** Object:  StoredProcedure [dbo].[prc_InsertSearch_VerboseIndexLookupQueryLatency]    Script Date: 11/10/2016 4:16:42 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[prc_InsertSearch_VerboseIndexLookupQueryLatency]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[prc_InsertSearch_VerboseIndexLookupQueryLatency]    
        @ApplicationId UniqueIdentifier, @NodeName NVarChar(256), @CorrelationId UniqueIdentifier, @TotalQueryTimeMs Int, @QueryTree NVarChar(4000), @OperationType Bit, @FirstPassMs Int, @SecondPassMs Int, @TangoTimeMs Int, @MergeTimeMs Int, @QueryLookupMs Int, @DocSumLookupMs Int, @AverageQueuingTimeMs Int, @AverageTransferTimeMs Int, @TotalHits BigInt, @TotalHitsWithDuplicates BigInt, @TotalBytesReceived BigInt,         
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
        SELECT @ConfigName = ''Retention Period - Search_VerboseIndexLookupQueryLatency''
        SELECT @RetentionPeriod = CAST(dbo.fn_GetConfigValue(@ConfigName)  as smallint)
        IF (datediff(dd, @LogTime, @UTCDate) > @RetentionPeriod OR
            datediff(hh, @LogTime, @UTCDate) < 0)
        BEGIN
            RETURN
        END
	SELECT @ConfigName = ''Max Total Bytes - Search_VerboseIndexLookupQueryLatency''
	SELECT @MaxBytes = CAST(dbo.fn_GetConfigValue(@ConfigName) as bigint) / @RetentionPeriod
        SELECT @PartitionId = dbo.fn_GetPartitionId(@LogTime)
        exec dbo.prc_LogAndRollOverPartition ''Search_VerboseIndexLookupQueryLatency'', @UTCDate 
		-- Silently fail if the partition is full.
		IF (dbo.fn_GetPartitionSize(''Search_VerboseIndexLookupQueryLatency_Partition'' + CAST(@PartitionId as NVARCHAR(MAX))) >= @MaxBytes)
		BEGIN
			RETURN
		END
        DECLARE @SQL nvarchar(MAX), 
		        @SQLParams nvarchar(MAX)
        SELECT @SQL =
	           CAST(''INSERT INTO [dbo].[Search_VerboseIndexLookupQueryLatency_Partition'' AS NVARCHAR(MAX)) + CAST(@PartitionId as NVARCHAR(MAX)) + CAST('']
			        (PartitionId, 
			        LogTime,
			        MachineName,
                ApplicationId, NodeName, CorrelationId, TotalQueryTimeMs, QueryTree, OperationType, FirstPassMs, SecondPassMs, TangoTimeMs, MergeTimeMs, QueryLookupMs, DocSumLookupMs, AverageQueuingTimeMs, AverageTransferTimeMs, TotalHits, TotalHitsWithDuplicates, TotalBytesReceived, 
			        RowCreatedTime) 
		        SELECT 
			        @PartitionId,
			        @LogTime,
			        @MachineName,
                @ApplicationId, @NodeName, @CorrelationId, @TotalQueryTimeMs, @QueryTree, @OperationType, @FirstPassMs, @SecondPassMs, @TangoTimeMs, @MergeTimeMs, @QueryLookupMs, @DocSumLookupMs, @AverageQueuingTimeMs, @AverageTransferTimeMs, @TotalHits, @TotalHitsWithDuplicates, @TotalBytesReceived, 
			        @UTCDate'' AS NVARCHAR(MAX))
        SELECT @SQLParams = 
		        ''@PartitionId tinyint,
		        @LogTime datetime,
		        @MachineName nvarchar(128),
                @ApplicationId UniqueIdentifier, @NodeName NVarChar(256), @CorrelationId UniqueIdentifier, @TotalQueryTimeMs Int, @QueryTree NVarChar(4000), @OperationType Bit, @FirstPassMs Int, @SecondPassMs Int, @TangoTimeMs Int, @MergeTimeMs Int, @QueryLookupMs Int, @DocSumLookupMs Int, @AverageQueuingTimeMs Int, @AverageTransferTimeMs Int, @TotalHits BigInt, @TotalHitsWithDuplicates BigInt, @TotalBytesReceived BigInt,         
		        @UTCDate datetime''
        exec sp_executesql
	        @SQL,
	        @SQLParams,
	        @PartitionId,
            @LogTime,
            @MachineName,
	        @ApplicationId, @NodeName, @CorrelationId, @TotalQueryTimeMs, @QueryTree, @OperationType, @FirstPassMs, @SecondPassMs, @TangoTimeMs, @MergeTimeMs, @QueryLookupMs, @DocSumLookupMs, @AverageQueuingTimeMs, @AverageTransferTimeMs, @TotalHits, @TotalHitsWithDuplicates, @TotalBytesReceived, 
            @UTCDate
    END' 
END
GO
