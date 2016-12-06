USE [DSSPPROD_UsageAndHealth]
GO
/****** Object:  Table [dbo].[BandwidthUsage_Partition21]    Script Date: 11/10/2016 4:16:42 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[BandwidthUsage_Partition21]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[BandwidthUsage_Partition21](
	[PartitionId] [tinyint] NULL,
	[RowId] [uniqueidentifier] NOT NULL,
	[LogTime] [datetime] NOT NULL,
	[MachineName] [nvarchar](128) NOT NULL,
	[FarmId] [uniqueidentifier] NULL,
	[SiteSubscriptionId] [uniqueidentifier] NULL,
	[UserLogin] [nvarchar](300) NULL,
	[CorrelationId] [uniqueidentifier] NULL,
	[ComponentId] [int] NULL,
	[ProductId] [uniqueidentifier] NULL,
	[RequestUrl] [nvarchar](260) NULL,
	[AccessType] [int] NULL,
	[RequestContentLen] [int] NULL,
	[ResponseContentLen] [int] NULL,
	[Result] [int] NULL,
	[Latency] [bigint] NULL,
	[RowCreatedTime] [datetime] NOT NULL
) ON [PRIMARY]
END
GO
/****** Object:  Index [IX_BandwidthUsage_ComponentId]    Script Date: 11/10/2016 4:16:47 PM ******/
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[BandwidthUsage_Partition21]') AND name = N'IX_BandwidthUsage_ComponentId')
CREATE NONCLUSTERED INDEX [IX_BandwidthUsage_ComponentId] ON [dbo].[BandwidthUsage_Partition21]
(
	[SiteSubscriptionId] ASC,
	[ComponentId] ASC,
	[LogTime] DESC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = ON, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_BandwidthUsage_ProductId]    Script Date: 11/10/2016 4:16:47 PM ******/
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[BandwidthUsage_Partition21]') AND name = N'IX_BandwidthUsage_ProductId')
CREATE NONCLUSTERED INDEX [IX_BandwidthUsage_ProductId] ON [dbo].[BandwidthUsage_Partition21]
(
	[SiteSubscriptionId] ASC,
	[ProductId] ASC,
	[LogTime] DESC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = ON, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_LogTime]    Script Date: 11/10/2016 4:16:47 PM ******/
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[BandwidthUsage_Partition21]') AND name = N'IX_LogTime')
CREATE NONCLUSTERED INDEX [IX_LogTime] ON [dbo].[BandwidthUsage_Partition21]
(
	[LogTime] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = ON, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [IX_MachineName]    Script Date: 11/10/2016 4:16:47 PM ******/
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[BandwidthUsage_Partition21]') AND name = N'IX_MachineName')
CREATE NONCLUSTERED INDEX [IX_MachineName] ON [dbo].[BandwidthUsage_Partition21]
(
	[MachineName] ASC,
	[LogTime] DESC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = ON, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[DF__Bandwidth__RowId__719CDDE7]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[BandwidthUsage_Partition21] ADD  DEFAULT (newsequentialid()) FOR [RowId]
END

GO
