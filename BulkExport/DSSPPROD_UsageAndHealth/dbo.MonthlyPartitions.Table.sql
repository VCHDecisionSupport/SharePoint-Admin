USE [DSSPPROD_UsageAndHealth]
GO
/****** Object:  Table [dbo].[MonthlyPartitions]    Script Date: 11/10/2016 4:16:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[MonthlyPartitions]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[MonthlyPartitions](
	[PartitionId] [tinyint] NOT NULL,
 CONSTRAINT [PK_MonthlyPartitions] PRIMARY KEY CLUSTERED 
(
	[PartitionId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = ON, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
