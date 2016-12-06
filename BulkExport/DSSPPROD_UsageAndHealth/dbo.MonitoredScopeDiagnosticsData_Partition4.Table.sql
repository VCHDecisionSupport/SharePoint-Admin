USE [DSSPPROD_UsageAndHealth]
GO
/****** Object:  Table [dbo].[MonitoredScopeDiagnosticsData_Partition4]    Script Date: 11/10/2016 4:16:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[MonitoredScopeDiagnosticsData_Partition4]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[MonitoredScopeDiagnosticsData_Partition4](
	[PartitionId] [tinyint] NULL,
	[RowId] [uniqueidentifier] NOT NULL,
	[LogTime] [datetime] NOT NULL,
	[MachineName] [nvarchar](128) NOT NULL,
	[CorrelationId] [uniqueidentifier] NULL,
	[ScopeId] [bigint] NULL,
	[Name] [nvarchar](256) NULL,
	[Flag] [bigint] NULL,
	[ValueInt] [bigint] NULL,
	[ValueFloat] [float] NULL,
	[ValueString] [nvarchar](512) NULL,
	[ValueBinary] [varbinary](max) NULL,
	[RowCreatedTime] [datetime] NOT NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [IX_RowCreatedTimeCorrelationId]    Script Date: 11/10/2016 4:16:47 PM ******/
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[MonitoredScopeDiagnosticsData_Partition4]') AND name = N'IX_RowCreatedTimeCorrelationId')
CREATE CLUSTERED INDEX [IX_RowCreatedTimeCorrelationId] ON [dbo].[MonitoredScopeDiagnosticsData_Partition4]
(
	[RowCreatedTime] ASC,
	[CorrelationId] ASC,
	[Name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = ON, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_CorrelationId]    Script Date: 11/10/2016 4:16:47 PM ******/
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[MonitoredScopeDiagnosticsData_Partition4]') AND name = N'IX_CorrelationId')
CREATE NONCLUSTERED INDEX [IX_CorrelationId] ON [dbo].[MonitoredScopeDiagnosticsData_Partition4]
(
	[CorrelationId] ASC,
	[ScopeId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = ON, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_LogTime]    Script Date: 11/10/2016 4:16:47 PM ******/
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[MonitoredScopeDiagnosticsData_Partition4]') AND name = N'IX_LogTime')
CREATE NONCLUSTERED INDEX [IX_LogTime] ON [dbo].[MonitoredScopeDiagnosticsData_Partition4]
(
	[LogTime] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = ON, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [IX_MachineName]    Script Date: 11/10/2016 4:16:47 PM ******/
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[MonitoredScopeDiagnosticsData_Partition4]') AND name = N'IX_MachineName')
CREATE NONCLUSTERED INDEX [IX_MachineName] ON [dbo].[MonitoredScopeDiagnosticsData_Partition4]
(
	[MachineName] ASC,
	[LogTime] DESC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = ON, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[DF__Monitored__RowId__36DC0ACC]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[MonitoredScopeDiagnosticsData_Partition4] ADD  DEFAULT (newsequentialid()) FOR [RowId]
END

GO
