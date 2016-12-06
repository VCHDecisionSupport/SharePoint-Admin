USE [DSSPPROD_UsageAndHealth]
GO
/****** Object:  View [dbo].[MonitoredScopes]    Script Date: 11/10/2016 4:16:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[MonitoredScopes]'))
EXEC dbo.sp_executesql @statement = N' CREATE VIEW [dbo].[MonitoredScopes] AS  SELECT * FROM [dbo].[MonitoredScopes_Partition0] with (NOLOCK) UNION ALL  SELECT * FROM [dbo].[MonitoredScopes_Partition1] with (NOLOCK) UNION ALL  SELECT * FROM [dbo].[MonitoredScopes_Partition2] with (NOLOCK) UNION ALL  SELECT * FROM [dbo].[MonitoredScopes_Partition3] with (NOLOCK) UNION ALL  SELECT * FROM [dbo].[MonitoredScopes_Partition4] with (NOLOCK) UNION ALL  SELECT * FROM [dbo].[MonitoredScopes_Partition5] with (NOLOCK) UNION ALL  SELECT * FROM [dbo].[MonitoredScopes_Partition6] with (NOLOCK) UNION ALL  SELECT * FROM [dbo].[MonitoredScopes_Partition7] with (NOLOCK) UNION ALL  SELECT * FROM [dbo].[MonitoredScopes_Partition8] with (NOLOCK) UNION ALL  SELECT * FROM [dbo].[MonitoredScopes_Partition9] with (NOLOCK) UNION ALL  SELECT * FROM [dbo].[MonitoredScopes_Partition10] with (NOLOCK) UNION ALL  SELECT * FROM [dbo].[MonitoredScopes_Partition11] with (NOLOCK) UNION ALL  SELECT * FROM [dbo].[MonitoredScopes_Partition12] with (NOLOCK) UNION ALL  SELECT * FROM [dbo].[MonitoredScopes_Partition13] with (NOLOCK) UNION ALL  SELECT * FROM [dbo].[MonitoredScopes_Partition14] with (NOLOCK) UNION ALL  SELECT * FROM [dbo].[MonitoredScopes_Partition15] with (NOLOCK) UNION ALL  SELECT * FROM [dbo].[MonitoredScopes_Partition16] with (NOLOCK) UNION ALL  SELECT * FROM [dbo].[MonitoredScopes_Partition17] with (NOLOCK) UNION ALL  SELECT * FROM [dbo].[MonitoredScopes_Partition18] with (NOLOCK) UNION ALL  SELECT * FROM [dbo].[MonitoredScopes_Partition19] with (NOLOCK) UNION ALL  SELECT * FROM [dbo].[MonitoredScopes_Partition20] with (NOLOCK) UNION ALL  SELECT * FROM [dbo].[MonitoredScopes_Partition21] with (NOLOCK) UNION ALL  SELECT * FROM [dbo].[MonitoredScopes_Partition22] with (NOLOCK) UNION ALL  SELECT * FROM [dbo].[MonitoredScopes_Partition23] with (NOLOCK) UNION ALL  SELECT * FROM [dbo].[MonitoredScopes_Partition24] with (NOLOCK) UNION ALL  SELECT * FROM [dbo].[MonitoredScopes_Partition25] with (NOLOCK) UNION ALL  SELECT * FROM [dbo].[MonitoredScopes_Partition26] with (NOLOCK) UNION ALL  SELECT * FROM [dbo].[MonitoredScopes_Partition27] with (NOLOCK) UNION ALL  SELECT * FROM [dbo].[MonitoredScopes_Partition28] with (NOLOCK) UNION ALL  SELECT * FROM [dbo].[MonitoredScopes_Partition29] with (NOLOCK) UNION ALL  SELECT * FROM [dbo].[MonitoredScopes_Partition30] with (NOLOCK) UNION ALL  SELECT * FROM [dbo].[MonitoredScopes_Partition31]' 
GO
