USE [DSSPPROD_UsageAndHealth]
GO
/****** Object:  Table [dbo].[MicroblogUsageTelemetry_Partition27]    Script Date: 11/10/2016 4:16:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[MicroblogUsageTelemetry_Partition27]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[MicroblogUsageTelemetry_Partition27](
	[PartitionId] [tinyint] NULL,
	[RowId] [uniqueidentifier] NOT NULL DEFAULT (newsequentialid()),
	[LogTime] [datetime] NOT NULL,
	[MachineName] [nvarchar](128) NOT NULL,
	[FarmId] [uniqueidentifier] NULL,
	[SiteSubscriptionId] [uniqueidentifier] NULL,
	[UserLogin] [nvarchar](300) NULL,
	[CorrelationId] [uniqueidentifier] NULL,
	[TopScopeName] [nvarchar](256) NULL,
	[TotalDuration] [bigint] NULL,
	[SQLQuery_Count] [int] NULL,
	[SQLQuery_Duration] [bigint] NULL,
	[MicroblogService_Duration] [bigint] NULL,
	[FeedCacheImpl_Count] [int] NULL,
	[FeedCacheImpl_Duration] [bigint] NULL,
	[DistributedCache_ReadWrite_Count] [int] NULL,
	[DistributedCache_ReadWrite_Duration] [bigint] NULL,
	[DistributedCache_Call_Count] [int] NULL,
	[DistributedCache_Call_Duration] [bigint] NULL,
	[FeedCacheImpl_Repopulation_Count] [int] NULL,
	[FeedCacheImpl_Repopulation_Duration] [bigint] NULL,
	[FeedCacheImpl_GetConsolidated_Duration] [bigint] NULL,
	[FeedCacheImpl_GetPublished_Duration] [bigint] NULL,
	[FeedCacheImpl_GetCategorical_Duration] [bigint] NULL,
	[FeedCacheImpl_GetEntries_Duration] [bigint] NULL,
	[DistributedCache_LMTQuery_Count] [int] NULL,
	[DistributedCache_LMTQuery_Duration] [bigint] NULL,
	[DistributedCache_GetObjectsByAnyTag_RegionCount] [int] NULL,
	[DistributedCache_GetObjectsByAnyTag_Duration] [bigint] NULL,
	[DistributedCache_GetObjectsByAnyTag_TotalTagCount] [int] NULL,
	[DistributedCache_GetObjectsByAnyTag_MaxTagCount] [int] NULL,
	[FeedCacheImpl_PostData_Count] [int] NULL,
	[FeedCacheImpl_PostData_Size] [bigint] NULL,
	[FeedCacheImpl_AddEntry_LMTMaxEntryCount] [int] NULL,
	[FeedCacheImpl_EntityCleanup_Duration] [bigint] NULL,
	[MicroblogService_FollowedEntity_Count] [int] NULL,
	[MicroblogService_PopulateSocialGraph_Duration] [bigint] NULL,
	[MicroblogService_ProcessFeed_Duration] [bigint] NULL,
	[MicroblogService_ProcessReferencePosts_Duration] [bigint] NULL,
	[MicroblogService_ReferenceThread_Count] [int] NULL,
	[MicroblogService_ConsolidatedFeed_Count] [int] NULL,
	[MicroblogService_FeedParticipant_Count] [int] NULL,
	[FeedCacheService_FollowedEntity_Count] [int] NULL,
	[FeedCacheService_FeedCacheEntry_Count] [int] NULL,
	[Flags] [int] NULL,
	[RowCreatedTime] [datetime] NOT NULL
) ON [PRIMARY]
END
GO
/****** Object:  Index [IX_LogTime]    Script Date: 11/10/2016 4:16:47 PM ******/
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[MicroblogUsageTelemetry_Partition27]') AND name = N'IX_LogTime')
CREATE NONCLUSTERED INDEX [IX_LogTime] ON [dbo].[MicroblogUsageTelemetry_Partition27]
(
	[LogTime] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = ON, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [IX_MachineName]    Script Date: 11/10/2016 4:16:47 PM ******/
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[MicroblogUsageTelemetry_Partition27]') AND name = N'IX_MachineName')
CREATE NONCLUSTERED INDEX [IX_MachineName] ON [dbo].[MicroblogUsageTelemetry_Partition27]
(
	[MachineName] ASC,
	[LogTime] DESC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = ON, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
