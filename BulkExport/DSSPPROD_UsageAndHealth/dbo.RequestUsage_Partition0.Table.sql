USE [DSSPPROD_UsageAndHealth]
GO
/****** Object:  Table [dbo].[RequestUsage_Partition0]    Script Date: 11/10/2016 4:16:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[RequestUsage_Partition0]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[RequestUsage_Partition0](
	[PartitionId] [tinyint] NULL,
	[RowId] [uniqueidentifier] NOT NULL,
	[LogTime] [datetime] NOT NULL,
	[MachineName] [nvarchar](128) NOT NULL,
	[FarmId] [uniqueidentifier] NULL,
	[SiteSubscriptionId] [uniqueidentifier] NULL,
	[UserLogin] [nvarchar](300) NULL,
	[CorrelationId] [uniqueidentifier] NULL,
	[WebApplicationId] [uniqueidentifier] NULL,
	[ServerUrl] [nvarchar](256) NULL,
	[SiteId] [uniqueidentifier] NULL,
	[SiteUrl] [nvarchar](256) NULL,
	[WebId] [uniqueidentifier] NULL,
	[WebUrl] [nvarchar](256) NULL,
	[DocumentPath] [nvarchar](256) NULL,
	[ContentTypeId] [nvarchar](1024) NULL,
	[QueryString] [nvarchar](512) NULL,
	[BytesConsumed] [int] NULL,
	[HttpStatus] [smallint] NULL,
	[SessionId] [nvarchar](64) NULL,
	[ReferrerUrl] [nvarchar](260) NULL,
	[ReferrerQueryString] [nvarchar](512) NULL,
	[Browser] [nvarchar](128) NULL,
	[UserAgent] [nvarchar](512) NULL,
	[UserAddress] [nvarchar](46) NULL,
	[RequestCount] [smallint] NULL,
	[QueryCount] [smallint] NULL,
	[QueryDurationSum] [bigint] NULL,
	[ServiceCallCount] [smallint] NULL,
	[ServiceCallDurationSum] [bigint] NULL,
	[OperationCount] [bigint] NULL,
	[Duration] [bigint] NULL,
	[RequestType] [nvarchar](16) NULL,
	[Title] [nvarchar](128) NULL,
	[SqlLogicalReads] [bigint] NULL,
	[CPUMCycles] [bigint] NULL,
	[CPUDuration] [bigint] NULL,
	[DistributedCacheReads] [bigint] NULL,
	[DistributedCacheReadsDuration] [bigint] NULL,
	[DistributedCacheReadsSize] [bigint] NULL,
	[DistributedCacheWrites] [bigint] NULL,
	[DistributedCacheWritesDuration] [bigint] NULL,
	[DistributedCacheWritesSize] [bigint] NULL,
	[DistributedCacheMisses] [bigint] NULL,
	[DistributedCacheHits] [bigint] NULL,
	[DistributedCacheFailures] [bigint] NULL,
	[DistributedCachedObjectsRequested] [bigint] NULL,
	[ManagedMemoryBytes] [bigint] NULL,
	[ManagedMemoryBytesLOH] [bigint] NULL,
	[IisLatency] [bigint] NULL,
	[RequestManagementRoutedServerUrl] [nvarchar](256) NULL,
	[RequestManagementThrottled] [bit] NULL,
	[RequestManagementUploadDuration] [bigint] NULL,
	[RequestManagementResponseDuration] [bigint] NULL,
	[RequestManagementDownloadDuration] [bigint] NULL,
	[HeadersForwarded] [nvarchar](256) NULL,
	[ClaimsAuthenticationTime] [bigint] NULL,
	[ClaimsAuthenticationTimeType] [nvarchar](60) NULL,
	[MUIEnabled] [bit] NULL,
	[WebCulture] [int] NULL,
	[UICulture] [int] NULL,
	[LargeGapStartTag] [nvarchar](16) NULL,
	[LargeGapEndTag] [nvarchar](16) NULL,
	[LargeGapTime] [bigint] NULL,
	[RowCreatedTime] [datetime] NOT NULL,
	[DocumentPathOriginalCasing] [nvarchar](256) NULL
) ON [PRIMARY]
END
GO
/****** Object:  Index [IX_CorrelationID]    Script Date: 11/10/2016 4:16:48 PM ******/
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[RequestUsage_Partition0]') AND name = N'IX_CorrelationID')
CREATE NONCLUSTERED INDEX [IX_CorrelationID] ON [dbo].[RequestUsage_Partition0]
(
	[PartitionId] ASC,
	[CorrelationId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = ON, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_LogTime]    Script Date: 11/10/2016 4:16:48 PM ******/
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[RequestUsage_Partition0]') AND name = N'IX_LogTime')
CREATE NONCLUSTERED INDEX [IX_LogTime] ON [dbo].[RequestUsage_Partition0]
(
	[LogTime] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = ON, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [IX_MachineName]    Script Date: 11/10/2016 4:16:48 PM ******/
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[RequestUsage_Partition0]') AND name = N'IX_MachineName')
CREATE NONCLUSTERED INDEX [IX_MachineName] ON [dbo].[RequestUsage_Partition0]
(
	[MachineName] ASC,
	[LogTime] DESC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = ON, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_RequestUsage_WebId]    Script Date: 11/10/2016 4:16:48 PM ******/
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[RequestUsage_Partition0]') AND name = N'IX_RequestUsage_WebId')
CREATE NONCLUSTERED INDEX [IX_RequestUsage_WebId] ON [dbo].[RequestUsage_Partition0]
(
	[PartitionId] ASC,
	[WebId] ASC,
	[LogTime] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = ON, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[DF__RequestUs__RowId__520F23F5]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[RequestUsage_Partition0] ADD  DEFAULT (newsequentialid()) FOR [RowId]
END

GO
