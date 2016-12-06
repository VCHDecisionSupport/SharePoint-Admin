USE [DSSPPROD_UsageAndHealth]
GO
/****** Object:  Table [dbo].[Search_VerboseWebPartQueryLatency_Partition1]    Script Date: 11/10/2016 4:16:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Search_VerboseWebPartQueryLatency_Partition1]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[Search_VerboseWebPartQueryLatency_Partition1](
	[PartitionId] [tinyint] NULL,
	[RowId] [uniqueidentifier] NOT NULL,
	[LogTime] [datetime] NOT NULL,
	[MachineName] [nvarchar](128) NOT NULL,
	[ApplicationId] [uniqueidentifier] NULL,
	[CorrelationId] [uniqueidentifier] NULL,
	[WebPartId] [uniqueidentifier] NULL,
	[WebPartTitle] [nvarchar](500) NULL,
	[ExclusiveWebpartTimeMs] [int] NULL,
	[InclusiveWebpartTimeMs] [int] NULL,
	[RowCreatedTime] [datetime] NOT NULL
) ON [PRIMARY]
END
GO
/****** Object:  Index [IX_LogTime]    Script Date: 11/10/2016 4:16:48 PM ******/
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[Search_VerboseWebPartQueryLatency_Partition1]') AND name = N'IX_LogTime')
CREATE NONCLUSTERED INDEX [IX_LogTime] ON [dbo].[Search_VerboseWebPartQueryLatency_Partition1]
(
	[LogTime] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = ON, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [IX_MachineName]    Script Date: 11/10/2016 4:16:48 PM ******/
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[Search_VerboseWebPartQueryLatency_Partition1]') AND name = N'IX_MachineName')
CREATE NONCLUSTERED INDEX [IX_MachineName] ON [dbo].[Search_VerboseWebPartQueryLatency_Partition1]
(
	[MachineName] ASC,
	[LogTime] DESC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = ON, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[DF__Search_Ve__RowId__12BEA5E7]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[Search_VerboseWebPartQueryLatency_Partition1] ADD  DEFAULT (newsequentialid()) FOR [RowId]
END

GO
