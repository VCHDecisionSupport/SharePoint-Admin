USE [DSSPPROD_UsageAndHealth]
GO
/****** Object:  View [dbo].[AnalysisServicesConnections]    Script Date: 11/10/2016 4:16:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[AnalysisServicesConnections]'))
EXEC dbo.sp_executesql @statement = N' CREATE VIEW [dbo].[AnalysisServicesConnections] AS  SELECT * FROM [dbo].[AnalysisServicesConnections_Partition0] with (NOLOCK) UNION ALL  SELECT * FROM [dbo].[AnalysisServicesConnections_Partition1] with (NOLOCK) UNION ALL  SELECT * FROM [dbo].[AnalysisServicesConnections_Partition2] with (NOLOCK) UNION ALL  SELECT * FROM [dbo].[AnalysisServicesConnections_Partition3] with (NOLOCK) UNION ALL  SELECT * FROM [dbo].[AnalysisServicesConnections_Partition4] with (NOLOCK) UNION ALL  SELECT * FROM [dbo].[AnalysisServicesConnections_Partition5] with (NOLOCK) UNION ALL  SELECT * FROM [dbo].[AnalysisServicesConnections_Partition6] with (NOLOCK) UNION ALL  SELECT * FROM [dbo].[AnalysisServicesConnections_Partition7] with (NOLOCK) UNION ALL  SELECT * FROM [dbo].[AnalysisServicesConnections_Partition8] with (NOLOCK) UNION ALL  SELECT * FROM [dbo].[AnalysisServicesConnections_Partition9] with (NOLOCK) UNION ALL  SELECT * FROM [dbo].[AnalysisServicesConnections_Partition10] with (NOLOCK) UNION ALL  SELECT * FROM [dbo].[AnalysisServicesConnections_Partition11] with (NOLOCK) UNION ALL  SELECT * FROM [dbo].[AnalysisServicesConnections_Partition12] with (NOLOCK) UNION ALL  SELECT * FROM [dbo].[AnalysisServicesConnections_Partition13] with (NOLOCK) UNION ALL  SELECT * FROM [dbo].[AnalysisServicesConnections_Partition14] with (NOLOCK) UNION ALL  SELECT * FROM [dbo].[AnalysisServicesConnections_Partition15] with (NOLOCK) UNION ALL  SELECT * FROM [dbo].[AnalysisServicesConnections_Partition16] with (NOLOCK) UNION ALL  SELECT * FROM [dbo].[AnalysisServicesConnections_Partition17] with (NOLOCK) UNION ALL  SELECT * FROM [dbo].[AnalysisServicesConnections_Partition18] with (NOLOCK) UNION ALL  SELECT * FROM [dbo].[AnalysisServicesConnections_Partition19] with (NOLOCK) UNION ALL  SELECT * FROM [dbo].[AnalysisServicesConnections_Partition20] with (NOLOCK) UNION ALL  SELECT * FROM [dbo].[AnalysisServicesConnections_Partition21] with (NOLOCK) UNION ALL  SELECT * FROM [dbo].[AnalysisServicesConnections_Partition22] with (NOLOCK) UNION ALL  SELECT * FROM [dbo].[AnalysisServicesConnections_Partition23] with (NOLOCK) UNION ALL  SELECT * FROM [dbo].[AnalysisServicesConnections_Partition24] with (NOLOCK) UNION ALL  SELECT * FROM [dbo].[AnalysisServicesConnections_Partition25] with (NOLOCK) UNION ALL  SELECT * FROM [dbo].[AnalysisServicesConnections_Partition26] with (NOLOCK) UNION ALL  SELECT * FROM [dbo].[AnalysisServicesConnections_Partition27] with (NOLOCK) UNION ALL  SELECT * FROM [dbo].[AnalysisServicesConnections_Partition28] with (NOLOCK) UNION ALL  SELECT * FROM [dbo].[AnalysisServicesConnections_Partition29] with (NOLOCK) UNION ALL  SELECT * FROM [dbo].[AnalysisServicesConnections_Partition30] with (NOLOCK) UNION ALL  SELECT * FROM [dbo].[AnalysisServicesConnections_Partition31]' 
GO
