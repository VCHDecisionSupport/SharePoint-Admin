USE [DSSPPROD_UsageAndHealth]
GO
/****** Object:  Table [dbo].[TimerJobUsage_Partition14]    Script Date: 11/10/2016 4:16:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TimerJobUsage_Partition14]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[TimerJobUsage_Partition14](
	[PartitionId] [tinyint] NULL,
	[RowId] [uniqueidentifier] NOT NULL,
	[LogTime] [datetime] NOT NULL,
	[MachineName] [nvarchar](128) NOT NULL,
	[FarmId] [uniqueidentifier] NULL,
	[SiteSubscriptionId] [uniqueidentifier] NULL,
	[UserLogin] [nvarchar](300) NULL,
	[CorrelationId] [uniqueidentifier] NULL,
	[ServiceId] [uniqueidentifier] NULL,
	[WebApplicationId] [uniqueidentifier] NULL,
	[JobId] [uniqueidentifier] NULL,
	[ServerId] [uniqueidentifier] NULL,
	[Status] [int] NULL,
	[StartTime] [datetime] NULL,
	[EndTime] [datetime] NULL,
	[WebApplicationName] [nvarchar](255) NULL,
	[JobTitle] [nvarchar](255) NULL,
	[RequestCount] [int] NULL,
	[QueryCount] [int] NULL,
	[QueryDurationSum] [bigint] NULL,
	[ServiceCallCount] [smallint] NULL,
	[ServiceCallDurationSum] [bigint] NULL,
	[Duration] [bigint] NULL,
	[CPUMCycles] [bigint] NULL,
	[CPUDuration] [bigint] NULL,
	[ManagedMemoryBytes] [bigint] NULL,
	[ManagedMemoryBytesLOH] [bigint] NULL,
	[RowCreatedTime] [datetime] NOT NULL
) ON [PRIMARY]
END
GO
/****** Object:  Index [IX_LogTime]    Script Date: 11/10/2016 4:16:49 PM ******/
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[TimerJobUsage_Partition14]') AND name = N'IX_LogTime')
CREATE NONCLUSTERED INDEX [IX_LogTime] ON [dbo].[TimerJobUsage_Partition14]
(
	[LogTime] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = ON, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [IX_MachineName]    Script Date: 11/10/2016 4:16:49 PM ******/
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[TimerJobUsage_Partition14]') AND name = N'IX_MachineName')
CREATE NONCLUSTERED INDEX [IX_MachineName] ON [dbo].[TimerJobUsage_Partition14]
(
	[MachineName] ASC,
	[LogTime] DESC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = ON, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[DF__TimerJobU__RowId__75435199]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[TimerJobUsage_Partition14] ADD  DEFAULT (newsequentialid()) FOR [RowId]
END

GO
