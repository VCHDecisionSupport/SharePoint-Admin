USE [DSSPPROD_UsageAndHealth]
GO
/****** Object:  Table [dbo].[Search_PerMinuteTotalUIQueryLatency_Partition19]    Script Date: 11/10/2016 4:16:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Search_PerMinuteTotalUIQueryLatency_Partition19]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[Search_PerMinuteTotalUIQueryLatency_Partition19](
	[PartitionId] [tinyint] NULL,
	[RowId] [uniqueidentifier] NOT NULL DEFAULT (newsequentialid()),
	[LogTime] [datetime] NOT NULL,
	[MachineName] [nvarchar](128) NOT NULL,
	[ApplicationId] [uniqueidentifier] NULL,
	[TenantId] [nvarchar](1024) NULL,
	[ApplicationType] [nvarchar](1024) NULL,
	[ResultPageUrl] [nvarchar](4000) NULL,
	[ImsFlow] [nvarchar](1024) NULL,
	[CustomTags] [nvarchar](4000) NULL,
	[NumQueries] [int] NULL,
	[TotalQueryTimeMs] [int] NULL,
	[ExclusiveWebpartTimeMs] [int] NULL,
	[InclusiveWebpartTimeMs] [int] NULL,
	[RowCreatedTime] [datetime] NOT NULL
) ON [PRIMARY]
END
GO
/****** Object:  Index [IX_LogTime]    Script Date: 11/10/2016 4:16:48 PM ******/
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[Search_PerMinuteTotalUIQueryLatency_Partition19]') AND name = N'IX_LogTime')
CREATE NONCLUSTERED INDEX [IX_LogTime] ON [dbo].[Search_PerMinuteTotalUIQueryLatency_Partition19]
(
	[LogTime] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = ON, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [IX_MachineName]    Script Date: 11/10/2016 4:16:48 PM ******/
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[Search_PerMinuteTotalUIQueryLatency_Partition19]') AND name = N'IX_MachineName')
CREATE NONCLUSTERED INDEX [IX_MachineName] ON [dbo].[Search_PerMinuteTotalUIQueryLatency_Partition19]
(
	[MachineName] ASC,
	[LogTime] DESC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = ON, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
