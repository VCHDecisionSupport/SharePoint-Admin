USE [DSSPPROD_UsageAndHealth]
GO
/****** Object:  Table [dbo].[SandboxedRequestsMonitoredData_Partition15]    Script Date: 11/10/2016 4:16:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SandboxedRequestsMonitoredData_Partition15]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[SandboxedRequestsMonitoredData_Partition15](
	[PartitionId] [tinyint] NULL,
	[RowId] [uniqueidentifier] NOT NULL,
	[LogTime] [datetime] NOT NULL,
	[MachineName] [nvarchar](128) NOT NULL,
	[FarmId] [uniqueidentifier] NULL,
	[SiteSubscriptionId] [uniqueidentifier] NULL,
	[UserLogin] [nvarchar](300) NULL,
	[CorrelationId] [uniqueidentifier] NULL,
	[UsagePID] [int] NULL,
	[SiteId] [uniqueidentifier] NULL,
	[SolutionId] [uniqueidentifier] NULL,
	[SolutionHash] [nvarchar](44) NULL,
	[RequestId] [int] NULL,
	[WorkerPID] [int] NULL,
	[ProxyPID] [int] NULL,
	[PercentProcessorTime] [float] NULL,
	[ProcessVirtualBytes] [float] NULL,
	[ProcessHandleCount] [float] NULL,
	[ProcessThreadCount] [float] NULL,
	[ProcessIOBytes] [float] NULL,
	[CPUExecutionTime] [float] NULL,
	[ProcessCPUCycles] [float] NULL,
	[AbnormalProcessTerminationCount] [float] NULL,
	[CriticalExceptionCount] [float] NULL,
	[UnhandledExceptionCount] [float] NULL,
	[UnresponsiveprocessCount] [float] NULL,
	[RowCreatedTime] [datetime] NOT NULL
) ON [PRIMARY]
END
GO
/****** Object:  Index [IX_LogTime]    Script Date: 11/10/2016 4:16:48 PM ******/
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[SandboxedRequestsMonitoredData_Partition15]') AND name = N'IX_LogTime')
CREATE NONCLUSTERED INDEX [IX_LogTime] ON [dbo].[SandboxedRequestsMonitoredData_Partition15]
(
	[LogTime] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = ON, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [IX_MachineName]    Script Date: 11/10/2016 4:16:48 PM ******/
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[SandboxedRequestsMonitoredData_Partition15]') AND name = N'IX_MachineName')
CREATE NONCLUSTERED INDEX [IX_MachineName] ON [dbo].[SandboxedRequestsMonitoredData_Partition15]
(
	[MachineName] ASC,
	[LogTime] DESC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = ON, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[DF__Sandboxed__RowId__3138400F]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[SandboxedRequestsMonitoredData_Partition15] ADD  DEFAULT (newsequentialid()) FOR [RowId]
END

GO
