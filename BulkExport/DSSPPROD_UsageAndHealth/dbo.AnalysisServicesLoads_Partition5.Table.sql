USE [DSSPPROD_UsageAndHealth]
GO
/****** Object:  Table [dbo].[AnalysisServicesLoads_Partition5]    Script Date: 11/10/2016 4:16:42 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[AnalysisServicesLoads_Partition5]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[AnalysisServicesLoads_Partition5](
	[PartitionId] [tinyint] NULL,
	[RowId] [uniqueidentifier] NOT NULL,
	[LogTime] [datetime] NOT NULL,
	[MachineName] [nvarchar](128) NOT NULL,
	[FarmId] [uniqueidentifier] NULL,
	[SiteSubscriptionId] [uniqueidentifier] NULL,
	[UserLogin] [nvarchar](300) NULL,
	[CorrelationId] [uniqueidentifier] NULL,
	[AnalysisServicesInstance] [nvarchar](256) NULL,
	[DatabaseId] [uniqueidentifier] NULL,
	[ServiceApplicationId] [uniqueidentifier] NULL,
	[UserName] [nvarchar](400) NULL,
	[ImageUrl] [nvarchar](2048) NULL,
	[SPFileID] [uniqueidentifier] NULL,
	[SPSiteID] [uniqueidentifier] NULL,
	[VersionLabel] [nvarchar](10) NULL,
	[ImageSizeKB] [int] NULL,
	[EstimatedDatabaseSizeKB] [int] NULL,
	[HealthScoreStatistics] [xml] NULL,
	[ElapsedTime] [int] NULL,
	[RowCreatedTime] [datetime] NOT NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END
GO
/****** Object:  Index [IX_LogTime]    Script Date: 11/10/2016 4:16:47 PM ******/
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[AnalysisServicesLoads_Partition5]') AND name = N'IX_LogTime')
CREATE NONCLUSTERED INDEX [IX_LogTime] ON [dbo].[AnalysisServicesLoads_Partition5]
(
	[LogTime] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = ON, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [IX_MachineName]    Script Date: 11/10/2016 4:16:47 PM ******/
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[AnalysisServicesLoads_Partition5]') AND name = N'IX_MachineName')
CREATE NONCLUSTERED INDEX [IX_MachineName] ON [dbo].[AnalysisServicesLoads_Partition5]
(
	[MachineName] ASC,
	[LogTime] DESC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = ON, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[DF__AnalysisS__RowId__25924E90]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[AnalysisServicesLoads_Partition5] ADD  DEFAULT (newsequentialid()) FOR [RowId]
END

GO
