USE [DSSPPROD_UsageAndHealth]
GO
/****** Object:  UserDefinedFunction [dbo].[TVF_Search_CrawlLoad_LogTime]    Script Date: 11/10/2016 4:16:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TVF_Search_CrawlLoad_LogTime]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'CREATE FUNCTION [dbo].[TVF_Search_CrawlLoad_LogTime](@BeginTime DateTime,@EndTime DateTime) RETURNS TABLE AS RETURN WITH CTEALL AS ( SELECT * FROM [dbo].[Search_CrawlLoad_Partition0] WITH(NOLOCK, INDEX=IX_LogTime) WHERE LogTime Between @BeginTime and @EndTime UNION ALL  SELECT * FROM [dbo].[Search_CrawlLoad_Partition1] WITH(NOLOCK, INDEX=IX_LogTime) WHERE LogTime Between @BeginTime and @EndTime UNION ALL  SELECT * FROM [dbo].[Search_CrawlLoad_Partition2] WITH(NOLOCK, INDEX=IX_LogTime) WHERE LogTime Between @BeginTime and @EndTime UNION ALL  SELECT * FROM [dbo].[Search_CrawlLoad_Partition3] WITH(NOLOCK, INDEX=IX_LogTime) WHERE LogTime Between @BeginTime and @EndTime UNION ALL  SELECT * FROM [dbo].[Search_CrawlLoad_Partition4] WITH(NOLOCK, INDEX=IX_LogTime) WHERE LogTime Between @BeginTime and @EndTime UNION ALL  SELECT * FROM [dbo].[Search_CrawlLoad_Partition5] WITH(NOLOCK, INDEX=IX_LogTime) WHERE LogTime Between @BeginTime and @EndTime UNION ALL  SELECT * FROM [dbo].[Search_CrawlLoad_Partition6] WITH(NOLOCK, INDEX=IX_LogTime) WHERE LogTime Between @BeginTime and @EndTime UNION ALL  SELECT * FROM [dbo].[Search_CrawlLoad_Partition7] WITH(NOLOCK, INDEX=IX_LogTime) WHERE LogTime Between @BeginTime and @EndTime UNION ALL  SELECT * FROM [dbo].[Search_CrawlLoad_Partition8] WITH(NOLOCK, INDEX=IX_LogTime) WHERE LogTime Between @BeginTime and @EndTime UNION ALL  SELECT * FROM [dbo].[Search_CrawlLoad_Partition9] WITH(NOLOCK, INDEX=IX_LogTime) WHERE LogTime Between @BeginTime and @EndTime UNION ALL  SELECT * FROM [dbo].[Search_CrawlLoad_Partition10] WITH(NOLOCK, INDEX=IX_LogTime) WHERE LogTime Between @BeginTime and @EndTime UNION ALL  SELECT * FROM [dbo].[Search_CrawlLoad_Partition11] WITH(NOLOCK, INDEX=IX_LogTime) WHERE LogTime Between @BeginTime and @EndTime UNION ALL  SELECT * FROM [dbo].[Search_CrawlLoad_Partition12] WITH(NOLOCK, INDEX=IX_LogTime) WHERE LogTime Between @BeginTime and @EndTime UNION ALL  SELECT * FROM [dbo].[Search_CrawlLoad_Partition13] WITH(NOLOCK, INDEX=IX_LogTime) WHERE LogTime Between @BeginTime and @EndTime UNION ALL  SELECT * FROM [dbo].[Search_CrawlLoad_Partition14] WITH(NOLOCK, INDEX=IX_LogTime) WHERE LogTime Between @BeginTime and @EndTime UNION ALL  SELECT * FROM [dbo].[Search_CrawlLoad_Partition15] WITH(NOLOCK, INDEX=IX_LogTime) WHERE LogTime Between @BeginTime and @EndTime UNION ALL  SELECT * FROM [dbo].[Search_CrawlLoad_Partition16] WITH(NOLOCK, INDEX=IX_LogTime) WHERE LogTime Between @BeginTime and @EndTime UNION ALL  SELECT * FROM [dbo].[Search_CrawlLoad_Partition17] WITH(NOLOCK, INDEX=IX_LogTime) WHERE LogTime Between @BeginTime and @EndTime UNION ALL  SELECT * FROM [dbo].[Search_CrawlLoad_Partition18] WITH(NOLOCK, INDEX=IX_LogTime) WHERE LogTime Between @BeginTime and @EndTime UNION ALL  SELECT * FROM [dbo].[Search_CrawlLoad_Partition19] WITH(NOLOCK, INDEX=IX_LogTime) WHERE LogTime Between @BeginTime and @EndTime UNION ALL  SELECT * FROM [dbo].[Search_CrawlLoad_Partition20] WITH(NOLOCK, INDEX=IX_LogTime) WHERE LogTime Between @BeginTime and @EndTime UNION ALL  SELECT * FROM [dbo].[Search_CrawlLoad_Partition21] WITH(NOLOCK, INDEX=IX_LogTime) WHERE LogTime Between @BeginTime and @EndTime UNION ALL  SELECT * FROM [dbo].[Search_CrawlLoad_Partition22] WITH(NOLOCK, INDEX=IX_LogTime) WHERE LogTime Between @BeginTime and @EndTime UNION ALL  SELECT * FROM [dbo].[Search_CrawlLoad_Partition23] WITH(NOLOCK, INDEX=IX_LogTime) WHERE LogTime Between @BeginTime and @EndTime UNION ALL  SELECT * FROM [dbo].[Search_CrawlLoad_Partition24] WITH(NOLOCK, INDEX=IX_LogTime) WHERE LogTime Between @BeginTime and @EndTime UNION ALL  SELECT * FROM [dbo].[Search_CrawlLoad_Partition25] WITH(NOLOCK, INDEX=IX_LogTime) WHERE LogTime Between @BeginTime and @EndTime UNION ALL  SELECT * FROM [dbo].[Search_CrawlLoad_Partition26] WITH(NOLOCK, INDEX=IX_LogTime) WHERE LogTime Between @BeginTime and @EndTime UNION ALL  SELECT * FROM [dbo].[Search_CrawlLoad_Partition27] WITH(NOLOCK, INDEX=IX_LogTime) WHERE LogTime Between @BeginTime and @EndTime UNION ALL  SELECT * FROM [dbo].[Search_CrawlLoad_Partition28] WITH(NOLOCK, INDEX=IX_LogTime) WHERE LogTime Between @BeginTime and @EndTime UNION ALL  SELECT * FROM [dbo].[Search_CrawlLoad_Partition29] WITH(NOLOCK, INDEX=IX_LogTime) WHERE LogTime Between @BeginTime and @EndTime UNION ALL  SELECT * FROM [dbo].[Search_CrawlLoad_Partition30] WITH(NOLOCK, INDEX=IX_LogTime) WHERE LogTime Between @BeginTime and @EndTime UNION ALL  SELECT * FROM [dbo].[Search_CrawlLoad_Partition31] WITH(NOLOCK, INDEX=IX_LogTime) WHERE LogTime Between @BeginTime and @EndTime) SELECT * FROM CTEALL' 
END

GO
