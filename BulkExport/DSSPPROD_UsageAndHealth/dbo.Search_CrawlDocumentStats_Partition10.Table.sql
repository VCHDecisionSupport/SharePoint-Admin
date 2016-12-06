USE [DSSPPROD_UsageAndHealth]
GO
/****** Object:  Table [dbo].[Search_CrawlDocumentStats_Partition10]    Script Date: 11/10/2016 4:16:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Search_CrawlDocumentStats_Partition10]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[Search_CrawlDocumentStats_Partition10](
	[PartitionId] [tinyint] NULL,
	[RowId] [uniqueidentifier] NOT NULL,
	[LogTime] [datetime] NOT NULL,
	[MachineName] [nvarchar](128) NOT NULL,
	[ApplicationId] [uniqueidentifier] NULL,
	[CrawlComponentId] [int] NULL,
	[CrawlId] [int] NULL,
	[ContentSourceId] [int] NULL,
	[NumDocuments] [bigint] NULL,
	[IsHighPriority] [int] NULL,
	[RepositoryTime] [bigint] NULL,
	[ProtocolHandlerTime] [bigint] NULL,
	[Filtering] [bigint] NULL,
	[CTSTime] [bigint] NULL,
	[SQLTime] [bigint] NULL,
	[GathererTime] [bigint] NULL,
	[TimeSpentInLinksTable] [bigint] NULL,
	[TimeSpentInQueue] [bigint] NULL,
	[ActionAddModify] [int] NULL,
	[ActionDelete] [int] NULL,
	[ActionSecurityOnly] [int] NULL,
	[ActionNoIndex] [int] NULL,
	[ActionNotModified] [int] NULL,
	[ActionSingleThreadedFD] [int] NULL,
	[ActionError] [int] NULL,
	[ActionRetry] [int] NULL,
	[ActionOther] [int] NULL,
	[LessThan15Min] [int] NULL,
	[LessThan30Min] [int] NULL,
	[LessThan1Hour] [int] NULL,
	[LessThan4Hours] [int] NULL,
	[LessThan1Day] [int] NULL,
	[LessThan1Week] [int] NULL,
	[LessThan1Month] [int] NULL,
	[GreaterThan1Month] [int] NULL,
	[ApplicationName] [nvarchar](1024) NULL,
	[ContentSourceName] [nvarchar](1024) NULL,
	[ThreadWaitingTime] [bigint] NULL,
	[NumGetRequests] [bigint] NULL,
	[NumPostRequests] [bigint] NULL,
	[DiscoveryTime] [bigint] NULL,
	[CTSTimeFromContentPipeline] [bigint] NULL,
	[IndexerTimeFromContentPipeline] [bigint] NULL,
	[LessThan2Min] [int] NULL,
	[LessThan5Min] [int] NULL,
	[LessThan10Min] [int] NULL,
	[LessThan20Min] [int] NULL,
	[LessThan45Min] [int] NULL,
	[LessThan2Hours] [int] NULL,
	[LessThan8Hours] [int] NULL,
	[LessThan12Hours] [int] NULL,
	[LessThan2Days] [int] NULL,
	[LessThan3Days] [int] NULL,
	[RowCreatedTime] [datetime] NOT NULL,
	[HybridParserTime] [bigint] NULL,
	[SPOTime] [bigint] NULL
) ON [PRIMARY]
END
GO
/****** Object:  Index [IX_LogTime]    Script Date: 11/10/2016 4:16:48 PM ******/
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[Search_CrawlDocumentStats_Partition10]') AND name = N'IX_LogTime')
CREATE NONCLUSTERED INDEX [IX_LogTime] ON [dbo].[Search_CrawlDocumentStats_Partition10]
(
	[LogTime] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = ON, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [IX_MachineName]    Script Date: 11/10/2016 4:16:48 PM ******/
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[Search_CrawlDocumentStats_Partition10]') AND name = N'IX_MachineName')
CREATE NONCLUSTERED INDEX [IX_MachineName] ON [dbo].[Search_CrawlDocumentStats_Partition10]
(
	[MachineName] ASC,
	[LogTime] DESC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = ON, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[DF__Search_Cr__RowId__68294D9D]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[Search_CrawlDocumentStats_Partition10] ADD  DEFAULT (newsequentialid()) FOR [RowId]
END

GO
