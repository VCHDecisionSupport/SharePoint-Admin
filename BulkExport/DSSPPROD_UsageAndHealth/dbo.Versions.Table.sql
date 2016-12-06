USE [DSSPPROD_UsageAndHealth]
GO
/****** Object:  Table [dbo].[Versions]    Script Date: 11/10/2016 4:16:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Versions]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[Versions](
	[VersionId] [uniqueidentifier] NOT NULL,
	[Version] [nvarchar](64) NOT NULL,
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[UserName] [nvarchar](255) NULL,
	[TimeStamp] [datetime] NULL,
	[FinalizeTimeStamp] [datetime] NULL,
	[Mode] [int] NULL,
	[ModeStack] [int] NULL,
	[Updates] [int] NOT NULL DEFAULT ((0)),
	[Notes] [nvarchar](1024) NULL,
 CONSTRAINT [Versions_PK] PRIMARY KEY CLUSTERED 
(
	[VersionId] ASC,
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = ON, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 95) ON [PRIMARY]
) ON [PRIMARY]
END
GO
