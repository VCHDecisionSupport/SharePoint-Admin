USE [DSSPPROD_UsageAndHealth]
GO
/****** Object:  View [dbo].[ImportUsage]    Script Date: 11/10/2016 4:16:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[ImportUsage]'))
EXEC dbo.sp_executesql @statement = N' CREATE VIEW [dbo].[ImportUsage] AS  SELECT * FROM [dbo].[ImportUsage_Partition0] with (NOLOCK) UNION ALL  SELECT * FROM [dbo].[ImportUsage_Partition1] with (NOLOCK) UNION ALL  SELECT * FROM [dbo].[ImportUsage_Partition2] with (NOLOCK) UNION ALL  SELECT * FROM [dbo].[ImportUsage_Partition3] with (NOLOCK) UNION ALL  SELECT * FROM [dbo].[ImportUsage_Partition4] with (NOLOCK) UNION ALL  SELECT * FROM [dbo].[ImportUsage_Partition5] with (NOLOCK) UNION ALL  SELECT * FROM [dbo].[ImportUsage_Partition6] with (NOLOCK) UNION ALL  SELECT * FROM [dbo].[ImportUsage_Partition7] with (NOLOCK) UNION ALL  SELECT * FROM [dbo].[ImportUsage_Partition8] with (NOLOCK) UNION ALL  SELECT * FROM [dbo].[ImportUsage_Partition9] with (NOLOCK) UNION ALL  SELECT * FROM [dbo].[ImportUsage_Partition10] with (NOLOCK) UNION ALL  SELECT * FROM [dbo].[ImportUsage_Partition11] with (NOLOCK) UNION ALL  SELECT * FROM [dbo].[ImportUsage_Partition12] with (NOLOCK) UNION ALL  SELECT * FROM [dbo].[ImportUsage_Partition13] with (NOLOCK) UNION ALL  SELECT * FROM [dbo].[ImportUsage_Partition14] with (NOLOCK) UNION ALL  SELECT * FROM [dbo].[ImportUsage_Partition15] with (NOLOCK) UNION ALL  SELECT * FROM [dbo].[ImportUsage_Partition16] with (NOLOCK) UNION ALL  SELECT * FROM [dbo].[ImportUsage_Partition17] with (NOLOCK) UNION ALL  SELECT * FROM [dbo].[ImportUsage_Partition18] with (NOLOCK) UNION ALL  SELECT * FROM [dbo].[ImportUsage_Partition19] with (NOLOCK) UNION ALL  SELECT * FROM [dbo].[ImportUsage_Partition20] with (NOLOCK) UNION ALL  SELECT * FROM [dbo].[ImportUsage_Partition21] with (NOLOCK) UNION ALL  SELECT * FROM [dbo].[ImportUsage_Partition22] with (NOLOCK) UNION ALL  SELECT * FROM [dbo].[ImportUsage_Partition23] with (NOLOCK) UNION ALL  SELECT * FROM [dbo].[ImportUsage_Partition24] with (NOLOCK) UNION ALL  SELECT * FROM [dbo].[ImportUsage_Partition25] with (NOLOCK) UNION ALL  SELECT * FROM [dbo].[ImportUsage_Partition26] with (NOLOCK) UNION ALL  SELECT * FROM [dbo].[ImportUsage_Partition27] with (NOLOCK) UNION ALL  SELECT * FROM [dbo].[ImportUsage_Partition28] with (NOLOCK) UNION ALL  SELECT * FROM [dbo].[ImportUsage_Partition29] with (NOLOCK) UNION ALL  SELECT * FROM [dbo].[ImportUsage_Partition30] with (NOLOCK) UNION ALL  SELECT * FROM [dbo].[ImportUsage_Partition31]' 
GO
