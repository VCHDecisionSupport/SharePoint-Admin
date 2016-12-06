USE [DSSPPROD_UsageAndHealth]
GO
/****** Object:  Table [dbo].[Search_VerboseQueryTags_Partition20]    Script Date: 11/10/2016 4:16:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Search_VerboseQueryTags_Partition20]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[Search_VerboseQueryTags_Partition20](
	[PartitionId] [tinyint] NULL,
	[RowId] [uniqueidentifier] NOT NULL,
	[LogTime] [datetime] NOT NULL,
	[MachineName] [nvarchar](128) NOT NULL,
	[CorrelationId] [uniqueidentifier] NULL,
	[ApplicationId] [uniqueidentifier] NULL,
	[TenantId] [nvarchar](1024) NULL,
	[ApplicationType] [nvarchar](1024) NULL,
	[ResultPageUrl] [nvarchar](4000) NULL,
	[ImsFlow] [nvarchar](1024) NULL,
	[ParentCorrelationId] [uniqueidentifier] NULL,
	[QueryId] [nvarchar](1024) NULL,
	[FederatedSourceId] [nvarchar](1024) NULL,
	[CustomTags] [nvarchar](4000) NULL,
	[QueryRuleName] [nvarchar](64) NULL,
	[RowCreatedTime] [datetime] NOT NULL
) ON [PRIMARY]
END
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [IX_ApplicationType]    Script Date: 11/10/2016 4:16:48 PM ******/
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[Search_VerboseQueryTags_Partition20]') AND name = N'IX_ApplicationType')
CREATE NONCLUSTERED INDEX [IX_ApplicationType] ON [dbo].[Search_VerboseQueryTags_Partition20]
(
	[ApplicationType] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = ON, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [IX_ImsFlow]    Script Date: 11/10/2016 4:16:48 PM ******/
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[Search_VerboseQueryTags_Partition20]') AND name = N'IX_ImsFlow')
CREATE NONCLUSTERED INDEX [IX_ImsFlow] ON [dbo].[Search_VerboseQueryTags_Partition20]
(
	[ImsFlow] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = ON, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_LogTime]    Script Date: 11/10/2016 4:16:48 PM ******/
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[Search_VerboseQueryTags_Partition20]') AND name = N'IX_LogTime')
CREATE NONCLUSTERED INDEX [IX_LogTime] ON [dbo].[Search_VerboseQueryTags_Partition20]
(
	[LogTime] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = ON, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [IX_MachineName]    Script Date: 11/10/2016 4:16:48 PM ******/
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[Search_VerboseQueryTags_Partition20]') AND name = N'IX_MachineName')
CREATE NONCLUSTERED INDEX [IX_MachineName] ON [dbo].[Search_VerboseQueryTags_Partition20]
(
	[MachineName] ASC,
	[LogTime] DESC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = ON, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [IX_ResultPageUrl]    Script Date: 11/10/2016 4:16:48 PM ******/
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[Search_VerboseQueryTags_Partition20]') AND name = N'IX_ResultPageUrl')
CREATE NONCLUSTERED INDEX [IX_ResultPageUrl] ON [dbo].[Search_VerboseQueryTags_Partition20]
(
	[ResultPageUrl] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = ON, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[DF__Search_Ve__RowId__746F28F1]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[Search_VerboseQueryTags_Partition20] ADD  DEFAULT (newsequentialid()) FOR [RowId]
END

GO
