USE [DSSPPROD_UsageAndHealth]
GO
/****** Object:  View [dbo].[Search_VerboseUIQueryLatency]    Script Date: 11/10/2016 4:16:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[Search_VerboseUIQueryLatency]'))
EXEC dbo.sp_executesql @statement = N' CREATE VIEW [dbo].[Search_VerboseUIQueryLatency] AS  SELECT * FROM [dbo].[Search_VerboseUIQueryLatency_Partition0] with (NOLOCK) UNION ALL  SELECT * FROM [dbo].[Search_VerboseUIQueryLatency_Partition1] with (NOLOCK) UNION ALL  SELECT * FROM [dbo].[Search_VerboseUIQueryLatency_Partition2] with (NOLOCK) UNION ALL  SELECT * FROM [dbo].[Search_VerboseUIQueryLatency_Partition3] with (NOLOCK) UNION ALL  SELECT * FROM [dbo].[Search_VerboseUIQueryLatency_Partition4] with (NOLOCK) UNION ALL  SELECT * FROM [dbo].[Search_VerboseUIQueryLatency_Partition5] with (NOLOCK) UNION ALL  SELECT * FROM [dbo].[Search_VerboseUIQueryLatency_Partition6] with (NOLOCK) UNION ALL  SELECT * FROM [dbo].[Search_VerboseUIQueryLatency_Partition7] with (NOLOCK) UNION ALL  SELECT * FROM [dbo].[Search_VerboseUIQueryLatency_Partition8] with (NOLOCK) UNION ALL  SELECT * FROM [dbo].[Search_VerboseUIQueryLatency_Partition9] with (NOLOCK) UNION ALL  SELECT * FROM [dbo].[Search_VerboseUIQueryLatency_Partition10] with (NOLOCK) UNION ALL  SELECT * FROM [dbo].[Search_VerboseUIQueryLatency_Partition11] with (NOLOCK) UNION ALL  SELECT * FROM [dbo].[Search_VerboseUIQueryLatency_Partition12] with (NOLOCK) UNION ALL  SELECT * FROM [dbo].[Search_VerboseUIQueryLatency_Partition13] with (NOLOCK) UNION ALL  SELECT * FROM [dbo].[Search_VerboseUIQueryLatency_Partition14] with (NOLOCK) UNION ALL  SELECT * FROM [dbo].[Search_VerboseUIQueryLatency_Partition15] with (NOLOCK) UNION ALL  SELECT * FROM [dbo].[Search_VerboseUIQueryLatency_Partition16] with (NOLOCK) UNION ALL  SELECT * FROM [dbo].[Search_VerboseUIQueryLatency_Partition17] with (NOLOCK) UNION ALL  SELECT * FROM [dbo].[Search_VerboseUIQueryLatency_Partition18] with (NOLOCK) UNION ALL  SELECT * FROM [dbo].[Search_VerboseUIQueryLatency_Partition19] with (NOLOCK) UNION ALL  SELECT * FROM [dbo].[Search_VerboseUIQueryLatency_Partition20] with (NOLOCK) UNION ALL  SELECT * FROM [dbo].[Search_VerboseUIQueryLatency_Partition21] with (NOLOCK) UNION ALL  SELECT * FROM [dbo].[Search_VerboseUIQueryLatency_Partition22] with (NOLOCK) UNION ALL  SELECT * FROM [dbo].[Search_VerboseUIQueryLatency_Partition23] with (NOLOCK) UNION ALL  SELECT * FROM [dbo].[Search_VerboseUIQueryLatency_Partition24] with (NOLOCK) UNION ALL  SELECT * FROM [dbo].[Search_VerboseUIQueryLatency_Partition25] with (NOLOCK) UNION ALL  SELECT * FROM [dbo].[Search_VerboseUIQueryLatency_Partition26] with (NOLOCK) UNION ALL  SELECT * FROM [dbo].[Search_VerboseUIQueryLatency_Partition27] with (NOLOCK) UNION ALL  SELECT * FROM [dbo].[Search_VerboseUIQueryLatency_Partition28] with (NOLOCK) UNION ALL  SELECT * FROM [dbo].[Search_VerboseUIQueryLatency_Partition29] with (NOLOCK) UNION ALL  SELECT * FROM [dbo].[Search_VerboseUIQueryLatency_Partition30] with (NOLOCK) UNION ALL  SELECT * FROM [dbo].[Search_VerboseUIQueryLatency_Partition31]' 
GO
