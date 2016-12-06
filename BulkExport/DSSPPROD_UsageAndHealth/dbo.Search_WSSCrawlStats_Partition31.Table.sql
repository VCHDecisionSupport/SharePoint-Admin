USE [DSSPPROD_UsageAndHealth]
GO
/****** Object:  Table [dbo].[Search_WSSCrawlStats_Partition31]    Script Date: 11/10/2016 4:16:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Search_WSSCrawlStats_Partition31]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[Search_WSSCrawlStats_Partition31](
	[PartitionId] [tinyint] NULL,
	[RowId] [uniqueidentifier] NOT NULL,
	[LogTime] [datetime] NOT NULL,
	[MachineName] [nvarchar](128) NOT NULL,
	[ContentDBHitCount] [int] NULL,
	[ContentDBTimeSpent] [int] NULL,
	[VirtualServerHitCount] [int] NULL,
	[VirtualServerTimeSpent] [int] NULL,
	[VirtualServerLocalCacheHitCount] [int] NULL,
	[VirtualServerLocalCacheMissCount] [int] NULL,
	[SiteCollectionHitCount] [int] NULL,
	[SiteCollectionTimeSpent] [int] NULL,
	[SiteCollectionLocalCacheHitCount] [int] NULL,
	[SiteCollectionLocalCacheMissCount] [int] NULL,
	[SiteCollectionGlobalCacheHitCount] [int] NULL,
	[SiteCollectionGlobalCacheMissCount] [int] NULL,
	[SiteHitCount] [int] NULL,
	[SiteTimeSpent] [int] NULL,
	[SiteLocalCacheHitCount] [int] NULL,
	[SiteLocalCacheMissCount] [int] NULL,
	[SiteGlobalCacheHitCount] [int] NULL,
	[SiteGlobalCacheMissCount] [int] NULL,
	[ListHitCount] [int] NULL,
	[ListTimeSpent] [int] NULL,
	[ListLocalCacheHitCount] [int] NULL,
	[ListLocalCacheMissCount] [int] NULL,
	[ListGlobalCacheHitCount] [int] NULL,
	[ListGlobalCacheMissCount] [int] NULL,
	[FolderHitCount] [int] NULL,
	[FolderTimeSpent] [int] NULL,
	[ListItemHitCount] [int] NULL,
	[ListItemTimeSpent] [int] NULL,
	[ListItemAttachmentsHitCount] [int] NULL,
	[ListItemAttachmentsTimeSpent] [int] NULL,
	[GetRequestsCount] [int] NULL,
	[GetRequestsTimeSpent] [int] NULL,
	[VirtualServerIISLatency] [int] NULL,
	[VirtualServerSPRequestDuration] [int] NULL,
	[ContentDBIISLatency] [int] NULL,
	[ContentDBSPRequestDuration] [int] NULL,
	[SiteCollectionIISLatency] [int] NULL,
	[SiteCollectionSPRequestDuration] [int] NULL,
	[SiteIISLatency] [int] NULL,
	[SiteSPRequestDuration] [int] NULL,
	[ListIISLatency] [int] NULL,
	[ListSPRequestDuration] [int] NULL,
	[FolderIISLatency] [int] NULL,
	[FolderSPRequestDuration] [int] NULL,
	[ListItemIISLatency] [int] NULL,
	[ListItemSPRequestDuration] [int] NULL,
	[ListItemAttachmentIISLatency] [int] NULL,
	[ListItemAttachmentSPRequestDuration] [int] NULL,
	[GetRequestIISLatency] [int] NULL,
	[GetRequestSPRequestDuration] [int] NULL,
	[RowCreatedTime] [datetime] NOT NULL
) ON [PRIMARY]
END
GO
/****** Object:  Index [IX_LogTime]    Script Date: 11/10/2016 4:16:48 PM ******/
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[Search_WSSCrawlStats_Partition31]') AND name = N'IX_LogTime')
CREATE NONCLUSTERED INDEX [IX_LogTime] ON [dbo].[Search_WSSCrawlStats_Partition31]
(
	[LogTime] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = ON, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [IX_MachineName]    Script Date: 11/10/2016 4:16:48 PM ******/
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[Search_WSSCrawlStats_Partition31]') AND name = N'IX_MachineName')
CREATE NONCLUSTERED INDEX [IX_MachineName] ON [dbo].[Search_WSSCrawlStats_Partition31]
(
	[MachineName] ASC,
	[LogTime] DESC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = ON, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[DF__Search_WS__RowId__11EA7D3F]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[Search_WSSCrawlStats_Partition31] ADD  DEFAULT (newsequentialid()) FOR [RowId]
END

GO
