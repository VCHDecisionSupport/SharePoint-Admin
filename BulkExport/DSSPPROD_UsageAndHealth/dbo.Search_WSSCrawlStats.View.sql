USE [DSSPPROD_UsageAndHealth]
GO
/****** Object:  View [dbo].[Search_WSSCrawlStats]    Script Date: 11/10/2016 4:16:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[Search_WSSCrawlStats]'))
EXEC dbo.sp_executesql @statement = N' CREATE VIEW [dbo].[Search_WSSCrawlStats] AS  SELECT * FROM [dbo].[Search_WSSCrawlStats_Partition0] with (NOLOCK) UNION ALL  SELECT * FROM [dbo].[Search_WSSCrawlStats_Partition1] with (NOLOCK) UNION ALL  SELECT * FROM [dbo].[Search_WSSCrawlStats_Partition2] with (NOLOCK) UNION ALL  SELECT * FROM [dbo].[Search_WSSCrawlStats_Partition3] with (NOLOCK) UNION ALL  SELECT * FROM [dbo].[Search_WSSCrawlStats_Partition4] with (NOLOCK) UNION ALL  SELECT * FROM [dbo].[Search_WSSCrawlStats_Partition5] with (NOLOCK) UNION ALL  SELECT * FROM [dbo].[Search_WSSCrawlStats_Partition6] with (NOLOCK) UNION ALL  SELECT * FROM [dbo].[Search_WSSCrawlStats_Partition7] with (NOLOCK) UNION ALL  SELECT * FROM [dbo].[Search_WSSCrawlStats_Partition8] with (NOLOCK) UNION ALL  SELECT * FROM [dbo].[Search_WSSCrawlStats_Partition9] with (NOLOCK) UNION ALL  SELECT * FROM [dbo].[Search_WSSCrawlStats_Partition10] with (NOLOCK) UNION ALL  SELECT * FROM [dbo].[Search_WSSCrawlStats_Partition11] with (NOLOCK) UNION ALL  SELECT * FROM [dbo].[Search_WSSCrawlStats_Partition12] with (NOLOCK) UNION ALL  SELECT * FROM [dbo].[Search_WSSCrawlStats_Partition13] with (NOLOCK) UNION ALL  SELECT * FROM [dbo].[Search_WSSCrawlStats_Partition14] with (NOLOCK) UNION ALL  SELECT * FROM [dbo].[Search_WSSCrawlStats_Partition15] with (NOLOCK) UNION ALL  SELECT * FROM [dbo].[Search_WSSCrawlStats_Partition16] with (NOLOCK) UNION ALL  SELECT * FROM [dbo].[Search_WSSCrawlStats_Partition17] with (NOLOCK) UNION ALL  SELECT * FROM [dbo].[Search_WSSCrawlStats_Partition18] with (NOLOCK) UNION ALL  SELECT * FROM [dbo].[Search_WSSCrawlStats_Partition19] with (NOLOCK) UNION ALL  SELECT * FROM [dbo].[Search_WSSCrawlStats_Partition20] with (NOLOCK) UNION ALL  SELECT * FROM [dbo].[Search_WSSCrawlStats_Partition21] with (NOLOCK) UNION ALL  SELECT * FROM [dbo].[Search_WSSCrawlStats_Partition22] with (NOLOCK) UNION ALL  SELECT * FROM [dbo].[Search_WSSCrawlStats_Partition23] with (NOLOCK) UNION ALL  SELECT * FROM [dbo].[Search_WSSCrawlStats_Partition24] with (NOLOCK) UNION ALL  SELECT * FROM [dbo].[Search_WSSCrawlStats_Partition25] with (NOLOCK) UNION ALL  SELECT * FROM [dbo].[Search_WSSCrawlStats_Partition26] with (NOLOCK) UNION ALL  SELECT * FROM [dbo].[Search_WSSCrawlStats_Partition27] with (NOLOCK) UNION ALL  SELECT * FROM [dbo].[Search_WSSCrawlStats_Partition28] with (NOLOCK) UNION ALL  SELECT * FROM [dbo].[Search_WSSCrawlStats_Partition29] with (NOLOCK) UNION ALL  SELECT * FROM [dbo].[Search_WSSCrawlStats_Partition30] with (NOLOCK) UNION ALL  SELECT * FROM [dbo].[Search_WSSCrawlStats_Partition31]' 
GO
