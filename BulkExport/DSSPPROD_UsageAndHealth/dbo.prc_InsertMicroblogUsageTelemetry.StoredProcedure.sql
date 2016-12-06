USE [DSSPPROD_UsageAndHealth]
GO
/****** Object:  StoredProcedure [dbo].[prc_InsertMicroblogUsageTelemetry]    Script Date: 11/10/2016 4:16:42 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[prc_InsertMicroblogUsageTelemetry]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[prc_InsertMicroblogUsageTelemetry]    
        @FarmId UniqueIdentifier, @SiteSubscriptionId UniqueIdentifier, @UserLogin NVarChar(300), @CorrelationId UniqueIdentifier, @TopScopeName NVarChar(256), @TotalDuration BigInt, @SQLQuery_Count Int, @SQLQuery_Duration BigInt, @MicroblogService_Duration BigInt, @FeedCacheImpl_Count Int, @FeedCacheImpl_Duration BigInt, @DistributedCache_ReadWrite_Count Int, @DistributedCache_ReadWrite_Duration BigInt, @DistributedCache_Call_Count Int, @DistributedCache_Call_Duration BigInt, @FeedCacheImpl_Repopulation_Count Int, @FeedCacheImpl_Repopulation_Duration BigInt, @FeedCacheImpl_GetConsolidated_Duration BigInt, @FeedCacheImpl_GetPublished_Duration BigInt, @FeedCacheImpl_GetCategorical_Duration BigInt, @FeedCacheImpl_GetEntries_Duration BigInt, @DistributedCache_LMTQuery_Count Int, @DistributedCache_LMTQuery_Duration BigInt, @DistributedCache_GetObjectsByAnyTag_RegionCount Int, @DistributedCache_GetObjectsByAnyTag_Duration BigInt, @DistributedCache_GetObjectsByAnyTag_TotalTagCount Int, @DistributedCache_GetObjectsByAnyTag_MaxTagCount Int, @FeedCacheImpl_PostData_Count Int, @FeedCacheImpl_PostData_Size BigInt, @FeedCacheImpl_AddEntry_LMTMaxEntryCount Int, @FeedCacheImpl_EntityCleanup_Duration BigInt, @MicroblogService_FollowedEntity_Count Int, @MicroblogService_PopulateSocialGraph_Duration BigInt, @MicroblogService_ProcessFeed_Duration BigInt, @MicroblogService_ProcessReferencePosts_Duration BigInt, @MicroblogService_ReferenceThread_Count Int, @MicroblogService_ConsolidatedFeed_Count Int, @MicroblogService_FeedParticipant_Count Int, @FeedCacheService_FollowedEntity_Count Int, @FeedCacheService_FeedCacheEntry_Count Int, @Flags Int,         
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
        SELECT @ConfigName = ''Retention Period - MicroblogUsageTelemetry''
        SELECT @RetentionPeriod = CAST(dbo.fn_GetConfigValue(@ConfigName)  as smallint)
        IF (datediff(dd, @LogTime, @UTCDate) > @RetentionPeriod OR
            datediff(hh, @LogTime, @UTCDate) < 0)
        BEGIN
            RETURN
        END
	SELECT @ConfigName = ''Max Total Bytes - MicroblogUsageTelemetry''
	SELECT @MaxBytes = CAST(dbo.fn_GetConfigValue(@ConfigName) as bigint) / @RetentionPeriod
        SELECT @PartitionId = dbo.fn_GetPartitionId(@LogTime)
        exec dbo.prc_LogAndRollOverPartition ''MicroblogUsageTelemetry'', @UTCDate 
		-- Silently fail if the partition is full.
		IF (dbo.fn_GetPartitionSize(''MicroblogUsageTelemetry_Partition'' + CAST(@PartitionId as NVARCHAR(MAX))) >= @MaxBytes)
		BEGIN
			RETURN
		END
        DECLARE @SQL nvarchar(MAX), 
		        @SQLParams nvarchar(MAX)
        SELECT @SQL =
	           CAST(''INSERT INTO [dbo].[MicroblogUsageTelemetry_Partition'' AS NVARCHAR(MAX)) + CAST(@PartitionId as NVARCHAR(MAX)) + CAST('']
			        (PartitionId, 
			        LogTime,
			        MachineName,
                FarmId, SiteSubscriptionId, UserLogin, CorrelationId, TopScopeName, TotalDuration, SQLQuery_Count, SQLQuery_Duration, MicroblogService_Duration, FeedCacheImpl_Count, FeedCacheImpl_Duration, DistributedCache_ReadWrite_Count, DistributedCache_ReadWrite_Duration, DistributedCache_Call_Count, DistributedCache_Call_Duration, FeedCacheImpl_Repopulation_Count, FeedCacheImpl_Repopulation_Duration, FeedCacheImpl_GetConsolidated_Duration, FeedCacheImpl_GetPublished_Duration, FeedCacheImpl_GetCategorical_Duration, FeedCacheImpl_GetEntries_Duration, DistributedCache_LMTQuery_Count, DistributedCache_LMTQuery_Duration, DistributedCache_GetObjectsByAnyTag_RegionCount, DistributedCache_GetObjectsByAnyTag_Duration, DistributedCache_GetObjectsByAnyTag_TotalTagCount, DistributedCache_GetObjectsByAnyTag_MaxTagCount, FeedCacheImpl_PostData_Count, FeedCacheImpl_PostData_Size, FeedCacheImpl_AddEntry_LMTMaxEntryCount, FeedCacheImpl_EntityCleanup_Duration, MicroblogService_FollowedEntity_Count, MicroblogService_PopulateSocialGraph_Duration, MicroblogService_ProcessFeed_Duration, MicroblogService_ProcessReferencePosts_Duration, MicroblogService_ReferenceThread_Count, MicroblogService_ConsolidatedFeed_Count, MicroblogService_FeedParticipant_Count, FeedCacheService_FollowedEntity_Count, FeedCacheService_FeedCacheEntry_Count, Flags, 
			        RowCreatedTime) 
		        SELECT 
			        @PartitionId,
			        @LogTime,
			        @MachineName,
                @FarmId, @SiteSubscriptionId, @UserLogin, @CorrelationId, @TopScopeName, @TotalDuration, @SQLQuery_Count, @SQLQuery_Duration, @MicroblogService_Duration, @FeedCacheImpl_Count, @FeedCacheImpl_Duration, @DistributedCache_ReadWrite_Count, @DistributedCache_ReadWrite_Duration, @DistributedCache_Call_Count, @DistributedCache_Call_Duration, @FeedCacheImpl_Repopulation_Count, @FeedCacheImpl_Repopulation_Duration, @FeedCacheImpl_GetConsolidated_Duration, @FeedCacheImpl_GetPublished_Duration, @FeedCacheImpl_GetCategorical_Duration, @FeedCacheImpl_GetEntries_Duration, @DistributedCache_LMTQuery_Count, @DistributedCache_LMTQuery_Duration, @DistributedCache_GetObjectsByAnyTag_RegionCount, @DistributedCache_GetObjectsByAnyTag_Duration, @DistributedCache_GetObjectsByAnyTag_TotalTagCount, @DistributedCache_GetObjectsByAnyTag_MaxTagCount, @FeedCacheImpl_PostData_Count, @FeedCacheImpl_PostData_Size, @FeedCacheImpl_AddEntry_LMTMaxEntryCount, @FeedCacheImpl_EntityCleanup_Duration, @MicroblogService_FollowedEntity_Count, @MicroblogService_PopulateSocialGraph_Duration, @MicroblogService_ProcessFeed_Duration, @MicroblogService_ProcessReferencePosts_Duration, @MicroblogService_ReferenceThread_Count, @MicroblogService_ConsolidatedFeed_Count, @MicroblogService_FeedParticipant_Count, @FeedCacheService_FollowedEntity_Count, @FeedCacheService_FeedCacheEntry_Count, @Flags, 
			        @UTCDate'' AS NVARCHAR(MAX))
        SELECT @SQLParams = 
		        ''@PartitionId tinyint,
		        @LogTime datetime,
		        @MachineName nvarchar(128),
                @FarmId UniqueIdentifier, @SiteSubscriptionId UniqueIdentifier, @UserLogin NVarChar(300), @CorrelationId UniqueIdentifier, @TopScopeName NVarChar(256), @TotalDuration BigInt, @SQLQuery_Count Int, @SQLQuery_Duration BigInt, @MicroblogService_Duration BigInt, @FeedCacheImpl_Count Int, @FeedCacheImpl_Duration BigInt, @DistributedCache_ReadWrite_Count Int, @DistributedCache_ReadWrite_Duration BigInt, @DistributedCache_Call_Count Int, @DistributedCache_Call_Duration BigInt, @FeedCacheImpl_Repopulation_Count Int, @FeedCacheImpl_Repopulation_Duration BigInt, @FeedCacheImpl_GetConsolidated_Duration BigInt, @FeedCacheImpl_GetPublished_Duration BigInt, @FeedCacheImpl_GetCategorical_Duration BigInt, @FeedCacheImpl_GetEntries_Duration BigInt, @DistributedCache_LMTQuery_Count Int, @DistributedCache_LMTQuery_Duration BigInt, @DistributedCache_GetObjectsByAnyTag_RegionCount Int, @DistributedCache_GetObjectsByAnyTag_Duration BigInt, @DistributedCache_GetObjectsByAnyTag_TotalTagCount Int, @DistributedCache_GetObjectsByAnyTag_MaxTagCount Int, @FeedCacheImpl_PostData_Count Int, @FeedCacheImpl_PostData_Size BigInt, @FeedCacheImpl_AddEntry_LMTMaxEntryCount Int, @FeedCacheImpl_EntityCleanup_Duration BigInt, @MicroblogService_FollowedEntity_Count Int, @MicroblogService_PopulateSocialGraph_Duration BigInt, @MicroblogService_ProcessFeed_Duration BigInt, @MicroblogService_ProcessReferencePosts_Duration BigInt, @MicroblogService_ReferenceThread_Count Int, @MicroblogService_ConsolidatedFeed_Count Int, @MicroblogService_FeedParticipant_Count Int, @FeedCacheService_FollowedEntity_Count Int, @FeedCacheService_FeedCacheEntry_Count Int, @Flags Int,         
		        @UTCDate datetime''
        exec sp_executesql
	        @SQL,
	        @SQLParams,
	        @PartitionId,
            @LogTime,
            @MachineName,
	        @FarmId, @SiteSubscriptionId, @UserLogin, @CorrelationId, @TopScopeName, @TotalDuration, @SQLQuery_Count, @SQLQuery_Duration, @MicroblogService_Duration, @FeedCacheImpl_Count, @FeedCacheImpl_Duration, @DistributedCache_ReadWrite_Count, @DistributedCache_ReadWrite_Duration, @DistributedCache_Call_Count, @DistributedCache_Call_Duration, @FeedCacheImpl_Repopulation_Count, @FeedCacheImpl_Repopulation_Duration, @FeedCacheImpl_GetConsolidated_Duration, @FeedCacheImpl_GetPublished_Duration, @FeedCacheImpl_GetCategorical_Duration, @FeedCacheImpl_GetEntries_Duration, @DistributedCache_LMTQuery_Count, @DistributedCache_LMTQuery_Duration, @DistributedCache_GetObjectsByAnyTag_RegionCount, @DistributedCache_GetObjectsByAnyTag_Duration, @DistributedCache_GetObjectsByAnyTag_TotalTagCount, @DistributedCache_GetObjectsByAnyTag_MaxTagCount, @FeedCacheImpl_PostData_Count, @FeedCacheImpl_PostData_Size, @FeedCacheImpl_AddEntry_LMTMaxEntryCount, @FeedCacheImpl_EntityCleanup_Duration, @MicroblogService_FollowedEntity_Count, @MicroblogService_PopulateSocialGraph_Duration, @MicroblogService_ProcessFeed_Duration, @MicroblogService_ProcessReferencePosts_Duration, @MicroblogService_ReferenceThread_Count, @MicroblogService_ConsolidatedFeed_Count, @MicroblogService_FeedParticipant_Count, @FeedCacheService_FollowedEntity_Count, @FeedCacheService_FeedCacheEntry_Count, @Flags, 
            @UTCDate
    END' 
END
GO
