USE [DSSPPROD_UsageAndHealth]
GO
/****** Object:  Table [dbo].[SPDistributedCacheCalls_Partition2]    Script Date: 11/10/2016 4:16:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SPDistributedCacheCalls_Partition2]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[SPDistributedCacheCalls_Partition2](
	[PartitionId] [tinyint] NULL,
	[RowId] [uniqueidentifier] NOT NULL,
	[LogTime] [datetime] NOT NULL,
	[MachineName] [nvarchar](128) NOT NULL,
	[FarmId] [uniqueidentifier] NULL,
	[SiteSubscriptionId] [uniqueidentifier] NULL,
	[UserLogin] [nvarchar](300) NULL,
	[CorrelationId] [uniqueidentifier] NULL,
	[DistributedCacheName] [nvarchar](255) NULL,
	[DistributedCacheApiName] [nvarchar](255) NULL,
	[DistributedCacheApiDuration] [bigint] NULL,
	[DistributedCacheObjectSize] [bigint] NULL,
	[DistributedCacheMisses] [bigint] NULL,
	[DistributedCacheHits] [bigint] NULL,
	[DistributedCacheFailures] [bigint] NULL,
	[DistributedCacheObjectsRequested] [bigint] NULL,
	[RowCreatedTime] [datetime] NOT NULL
) ON [PRIMARY]
END
GO
/****** Object:  Index [IX_LogTime]    Script Date: 11/10/2016 4:16:48 PM ******/
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[SPDistributedCacheCalls_Partition2]') AND name = N'IX_LogTime')
CREATE NONCLUSTERED INDEX [IX_LogTime] ON [dbo].[SPDistributedCacheCalls_Partition2]
(
	[LogTime] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = ON, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [IX_MachineName]    Script Date: 11/10/2016 4:16:48 PM ******/
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[SPDistributedCacheCalls_Partition2]') AND name = N'IX_MachineName')
CREATE NONCLUSTERED INDEX [IX_MachineName] ON [dbo].[SPDistributedCacheCalls_Partition2]
(
	[MachineName] ASC,
	[LogTime] DESC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = ON, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[DF__SPDistrib__RowId__52793849]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[SPDistributedCacheCalls_Partition2] ADD  DEFAULT (newsequentialid()) FOR [RowId]
END

GO
