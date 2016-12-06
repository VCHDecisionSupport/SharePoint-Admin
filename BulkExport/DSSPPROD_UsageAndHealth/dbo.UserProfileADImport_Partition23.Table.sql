USE [DSSPPROD_UsageAndHealth]
GO
/****** Object:  Table [dbo].[UserProfileADImport_Partition23]    Script Date: 11/10/2016 4:16:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[UserProfileADImport_Partition23]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[UserProfileADImport_Partition23](
	[PartitionId] [tinyint] NULL,
	[RowId] [uniqueidentifier] NOT NULL,
	[LogTime] [datetime] NOT NULL,
	[MachineName] [nvarchar](128) NOT NULL,
	[FarmId] [uniqueidentifier] NULL,
	[SiteSubscriptionId] [uniqueidentifier] NULL,
	[UserLogin] [nvarchar](300) NULL,
	[CorrelationId] [uniqueidentifier] NULL,
	[ImportStartTime] [datetime] NULL,
	[DcName] [nvarchar](128) NULL,
	[ImportEndTime] [datetime] NULL,
	[ImportSuccessCount] [bigint] NULL,
	[ImportFailureCount] [bigint] NULL,
	[ImportIgnoredCount] [bigint] NULL,
	[ImportTimeSpentInDirectory] [bigint] NULL,
	[ImportTimeSpentInProfile] [bigint] NULL,
	[ImportTimeSpentInDefrag] [bigint] NULL,
	[ImportDefragCount] [bigint] NULL,
	[ImportMaxDefragTime] [bigint] NULL,
	[RetrySuccessCount] [bigint] NULL,
	[RetryFailureCount] [bigint] NULL,
	[RetryIgnoredCount] [bigint] NULL,
	[RetryTimeSpentInDirectory] [bigint] NULL,
	[RetryTimeSpentInProfile] [bigint] NULL,
	[Message1] [nvarchar](3800) NULL,
	[Message2] [nvarchar](3800) NULL,
	[Message3] [nvarchar](3800) NULL,
	[Message4] [nvarchar](3800) NULL,
	[Message5] [nvarchar](3800) NULL,
	[Message6] [nvarchar](3800) NULL,
	[Message7] [nvarchar](3800) NULL,
	[Message8] [nvarchar](3800) NULL,
	[NumTenants] [bigint] NULL,
	[NumOUs] [bigint] NULL,
	[ExportAdds] [bigint] NULL,
	[ExportDeletes] [bigint] NULL,
	[ExportUpdates] [bigint] NULL,
	[TotalUsersInDB] [bigint] NULL,
	[TotalGroupsInDB] [bigint] NULL,
	[TerminationCode] [tinyint] NULL,
	[TotalUsersImported] [bigint] NULL,
	[TotalGroupsImported] [bigint] NULL,
	[RowCreatedTime] [datetime] NOT NULL
) ON [PRIMARY]
END
GO
/****** Object:  Index [IX_LogTime]    Script Date: 11/10/2016 4:16:49 PM ******/
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[UserProfileADImport_Partition23]') AND name = N'IX_LogTime')
CREATE NONCLUSTERED INDEX [IX_LogTime] ON [dbo].[UserProfileADImport_Partition23]
(
	[LogTime] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = ON, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [IX_MachineName]    Script Date: 11/10/2016 4:16:49 PM ******/
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[UserProfileADImport_Partition23]') AND name = N'IX_MachineName')
CREATE NONCLUSTERED INDEX [IX_MachineName] ON [dbo].[UserProfileADImport_Partition23]
(
	[MachineName] ASC,
	[LogTime] DESC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = ON, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[DF__UserProfi__RowId__47477CBF]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[UserProfileADImport_Partition23] ADD  DEFAULT (newsequentialid()) FOR [RowId]
END

GO
