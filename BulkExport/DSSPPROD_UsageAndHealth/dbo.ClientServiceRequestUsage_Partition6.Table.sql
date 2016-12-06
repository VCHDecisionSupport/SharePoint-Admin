USE [DSSPPROD_UsageAndHealth]
GO
/****** Object:  Table [dbo].[ClientServiceRequestUsage_Partition6]    Script Date: 11/10/2016 4:16:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ClientServiceRequestUsage_Partition6]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[ClientServiceRequestUsage_Partition6](
	[PartitionId] [tinyint] NULL,
	[RowId] [uniqueidentifier] NOT NULL,
	[LogTime] [datetime] NOT NULL,
	[MachineName] [nvarchar](128) NOT NULL,
	[FarmId] [uniqueidentifier] NULL,
	[SiteSubscriptionId] [uniqueidentifier] NULL,
	[UserLogin] [nvarchar](300) NULL,
	[CorrelationId] [uniqueidentifier] NULL,
	[ClientTag] [nvarchar](32) NULL,
	[UserAgent] [nvarchar](512) NULL,
	[RequestId] [uniqueidentifier] NULL,
	[AppId] [nvarchar](256) NULL,
	[IsRestRequest] [bit] NULL,
	[StartTime] [datetime] NULL,
	[Duration] [bigint] NULL,
	[ActionCount] [bigint] NULL,
	[ExceptionDetails] [nvarchar](3800) NULL,
	[RequestUrl] [nvarchar](260) NULL,
	[ErrorCode] [int] NULL,
	[RowCreatedTime] [datetime] NOT NULL
) ON [PRIMARY]
END
GO
/****** Object:  Index [IX_LogTime]    Script Date: 11/10/2016 4:16:47 PM ******/
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[ClientServiceRequestUsage_Partition6]') AND name = N'IX_LogTime')
CREATE NONCLUSTERED INDEX [IX_LogTime] ON [dbo].[ClientServiceRequestUsage_Partition6]
(
	[LogTime] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = ON, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [IX_MachineName]    Script Date: 11/10/2016 4:16:47 PM ******/
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[ClientServiceRequestUsage_Partition6]') AND name = N'IX_MachineName')
CREATE NONCLUSTERED INDEX [IX_MachineName] ON [dbo].[ClientServiceRequestUsage_Partition6]
(
	[MachineName] ASC,
	[LogTime] DESC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = ON, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[DF__ClientSer__RowId__5F3414E9]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[ClientServiceRequestUsage_Partition6] ADD  DEFAULT (newsequentialid()) FOR [RowId]
END

GO
