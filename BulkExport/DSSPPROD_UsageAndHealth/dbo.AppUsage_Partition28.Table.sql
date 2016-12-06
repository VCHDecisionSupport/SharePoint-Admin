USE [DSSPPROD_UsageAndHealth]
GO
/****** Object:  Table [dbo].[AppUsage_Partition28]    Script Date: 11/10/2016 4:16:42 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[AppUsage_Partition28]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[AppUsage_Partition28](
	[PartitionId] [tinyint] NULL,
	[RowId] [uniqueidentifier] NOT NULL,
	[LogTime] [datetime] NOT NULL,
	[MachineName] [nvarchar](128) NOT NULL,
	[FarmId] [uniqueidentifier] NULL,
	[SiteSubscriptionId] [uniqueidentifier] NULL,
	[UserLogin] [nvarchar](300) NULL,
	[CorrelationId] [uniqueidentifier] NULL,
	[SiteId] [uniqueidentifier] NULL,
	[WebId] [uniqueidentifier] NULL,
	[EventId] [int] NULL,
	[Value] [nvarchar](2048) NULL,
	[AppId] [uniqueidentifier] NULL,
	[AppInstanceId] [uniqueidentifier] NULL,
	[InstallLocation] [nvarchar](2048) NULL,
	[RowCreatedTime] [datetime] NOT NULL
) ON [PRIMARY]
END
GO
/****** Object:  Index [IX_AppUsage_AppId]    Script Date: 11/10/2016 4:16:47 PM ******/
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[AppUsage_Partition28]') AND name = N'IX_AppUsage_AppId')
CREATE NONCLUSTERED INDEX [IX_AppUsage_AppId] ON [dbo].[AppUsage_Partition28]
(
	[AppId] ASC,
	[SiteSubscriptionId] ASC,
	[LogTime] DESC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = ON, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_AppUsage_AppInstanceId]    Script Date: 11/10/2016 4:16:47 PM ******/
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[AppUsage_Partition28]') AND name = N'IX_AppUsage_AppInstanceId')
CREATE NONCLUSTERED INDEX [IX_AppUsage_AppInstanceId] ON [dbo].[AppUsage_Partition28]
(
	[AppInstanceId] ASC,
	[LogTime] DESC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = ON, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_LogTime]    Script Date: 11/10/2016 4:16:47 PM ******/
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[AppUsage_Partition28]') AND name = N'IX_LogTime')
CREATE NONCLUSTERED INDEX [IX_LogTime] ON [dbo].[AppUsage_Partition28]
(
	[LogTime] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = ON, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [IX_MachineName]    Script Date: 11/10/2016 4:16:47 PM ******/
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[AppUsage_Partition28]') AND name = N'IX_MachineName')
CREATE NONCLUSTERED INDEX [IX_MachineName] ON [dbo].[AppUsage_Partition28]
(
	[MachineName] ASC,
	[LogTime] DESC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = ON, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[DF__AppUsage___RowId__7D439ABD]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[AppUsage_Partition28] ADD  DEFAULT (newsequentialid()) FOR [RowId]
END

GO
