USE [DSSPPROD_UsageAndHealth]
GO
/****** Object:  Table [dbo].[EDU_OperationStatsUsage_Partition2]    Script Date: 11/10/2016 4:16:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[EDU_OperationStatsUsage_Partition2]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[EDU_OperationStatsUsage_Partition2](
	[PartitionId] [tinyint] NULL,
	[RowId] [uniqueidentifier] NOT NULL,
	[LogTime] [datetime] NOT NULL,
	[MachineName] [nvarchar](128) NOT NULL,
	[FarmId] [uniqueidentifier] NULL,
	[SiteSubscriptionId] [uniqueidentifier] NULL,
	[UserLogin] [nvarchar](300) NULL,
	[CorrelationId] [uniqueidentifier] NULL,
	[OperationId] [int] NULL,
	[WebAppId] [uniqueidentifier] NULL,
	[SiteId] [uniqueidentifier] NULL,
	[WebId] [uniqueidentifier] NULL,
	[SiteURL] [nvarchar](260) NULL,
	[WebUrl] [nvarchar](260) NULL,
	[OperationStatus] [tinyint] NULL,
	[Duration] [int] NULL,
	[StartTime] [datetime] NULL,
	[EndTime] [datetime] NULL,
	[CustomData] [nvarchar](2048) NULL,
	[RowCreatedTime] [datetime] NOT NULL
) ON [PRIMARY]
END
GO
/****** Object:  Index [IX_LogTime]    Script Date: 11/10/2016 4:16:47 PM ******/
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[EDU_OperationStatsUsage_Partition2]') AND name = N'IX_LogTime')
CREATE NONCLUSTERED INDEX [IX_LogTime] ON [dbo].[EDU_OperationStatsUsage_Partition2]
(
	[LogTime] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = ON, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [IX_MachineName]    Script Date: 11/10/2016 4:16:47 PM ******/
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[EDU_OperationStatsUsage_Partition2]') AND name = N'IX_MachineName')
CREATE NONCLUSTERED INDEX [IX_MachineName] ON [dbo].[EDU_OperationStatsUsage_Partition2]
(
	[MachineName] ASC,
	[LogTime] DESC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = ON, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[DF__EDU_Opera__RowId__0FEC5ADD]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[EDU_OperationStatsUsage_Partition2] ADD  DEFAULT (newsequentialid()) FOR [RowId]
END

GO
