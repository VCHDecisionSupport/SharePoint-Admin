USE [DSSPPROD_UsageAndHealth]
GO
/****** Object:  View [dbo].[Search_SystemMetrics]    Script Date: 11/10/2016 4:16:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[Search_SystemMetrics]'))
EXEC dbo.sp_executesql @statement = N' CREATE VIEW [dbo].[Search_SystemMetrics] AS  SELECT * FROM [dbo].[Search_SystemMetrics_Partition0] with (NOLOCK) UNION ALL  SELECT * FROM [dbo].[Search_SystemMetrics_Partition1] with (NOLOCK) UNION ALL  SELECT * FROM [dbo].[Search_SystemMetrics_Partition2] with (NOLOCK) UNION ALL  SELECT * FROM [dbo].[Search_SystemMetrics_Partition3] with (NOLOCK) UNION ALL  SELECT * FROM [dbo].[Search_SystemMetrics_Partition4] with (NOLOCK) UNION ALL  SELECT * FROM [dbo].[Search_SystemMetrics_Partition5] with (NOLOCK) UNION ALL  SELECT * FROM [dbo].[Search_SystemMetrics_Partition6] with (NOLOCK) UNION ALL  SELECT * FROM [dbo].[Search_SystemMetrics_Partition7] with (NOLOCK) UNION ALL  SELECT * FROM [dbo].[Search_SystemMetrics_Partition8] with (NOLOCK) UNION ALL  SELECT * FROM [dbo].[Search_SystemMetrics_Partition9] with (NOLOCK) UNION ALL  SELECT * FROM [dbo].[Search_SystemMetrics_Partition10] with (NOLOCK) UNION ALL  SELECT * FROM [dbo].[Search_SystemMetrics_Partition11] with (NOLOCK) UNION ALL  SELECT * FROM [dbo].[Search_SystemMetrics_Partition12] with (NOLOCK) UNION ALL  SELECT * FROM [dbo].[Search_SystemMetrics_Partition13] with (NOLOCK) UNION ALL  SELECT * FROM [dbo].[Search_SystemMetrics_Partition14] with (NOLOCK) UNION ALL  SELECT * FROM [dbo].[Search_SystemMetrics_Partition15] with (NOLOCK) UNION ALL  SELECT * FROM [dbo].[Search_SystemMetrics_Partition16] with (NOLOCK) UNION ALL  SELECT * FROM [dbo].[Search_SystemMetrics_Partition17] with (NOLOCK) UNION ALL  SELECT * FROM [dbo].[Search_SystemMetrics_Partition18] with (NOLOCK) UNION ALL  SELECT * FROM [dbo].[Search_SystemMetrics_Partition19] with (NOLOCK) UNION ALL  SELECT * FROM [dbo].[Search_SystemMetrics_Partition20] with (NOLOCK) UNION ALL  SELECT * FROM [dbo].[Search_SystemMetrics_Partition21] with (NOLOCK) UNION ALL  SELECT * FROM [dbo].[Search_SystemMetrics_Partition22] with (NOLOCK) UNION ALL  SELECT * FROM [dbo].[Search_SystemMetrics_Partition23] with (NOLOCK) UNION ALL  SELECT * FROM [dbo].[Search_SystemMetrics_Partition24] with (NOLOCK) UNION ALL  SELECT * FROM [dbo].[Search_SystemMetrics_Partition25] with (NOLOCK) UNION ALL  SELECT * FROM [dbo].[Search_SystemMetrics_Partition26] with (NOLOCK) UNION ALL  SELECT * FROM [dbo].[Search_SystemMetrics_Partition27] with (NOLOCK) UNION ALL  SELECT * FROM [dbo].[Search_SystemMetrics_Partition28] with (NOLOCK) UNION ALL  SELECT * FROM [dbo].[Search_SystemMetrics_Partition29] with (NOLOCK) UNION ALL  SELECT * FROM [dbo].[Search_SystemMetrics_Partition30] with (NOLOCK) UNION ALL  SELECT * FROM [dbo].[Search_SystemMetrics_Partition31]' 
GO
