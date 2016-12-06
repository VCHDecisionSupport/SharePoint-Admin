USE [DSSPPROD_UsageAndHealth]
GO
/****** Object:  StoredProcedure [dbo].[Search_GetCrawlFreshness]    Script Date: 11/10/2016 4:16:42 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Search_GetCrawlFreshness]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
        CREATE PROCEDURE [dbo].[Search_GetCrawlFreshness]
            @contentSources xml,
            @applicationId uniqueIdentifier,
            @startDate datetime,
            @endDate datetime,
            @crawlType int
        AS
        BEGIN
            WITH ContentSources(Id, AppId, Name) AS
            (
            SELECT nref.value(''@id'', ''int'') Id,
                   nref.value(''@appid'', ''uniqueidentifier'') AppId,
                   nref.value(''@name'', ''nvarchar(100)'') [Name]
            FROM   @contentSources.nodes(''//ContentSources/ContentSource'') AS R(nref)
            )
        SELECT
            SUM( LessThan2Min + LessThan5Min + LessThan10Min + LessThan20Min + LessThan45Min + LessThan2Hours + LessThan30Min + LessThan1Hour + LessThan4Hours ) AS LessThan4Hours,
            SUM( LessThan8Hours + LessThan12Hours + LessThan1Day) AS LessThan1Day,
            SUM( LessThan2Days ) AS LessThan2Days,
            SUM( LessThan3Days) AS LessThan3Days,
            MAX(LogTime) AS LogTime
        FROM Search_CrawlDocumentStats INNER JOIN ContentSources ON Search_CrawlDocumentStats.ContentSourceId = ContentSources.Id AND Search_CrawlDocumentStats.ApplicationId = ContentSources.AppId
            WHERE 
            (@applicationId = ''00000000-0000-0000-0000-000000000000'' OR ApplicationId = @applicationId) AND
            LogTime >= @startDate AND
            LogTime <= @endDate AND
            ((@crawlType>=2) OR (IsHighPriority = @crawlType)) AND
            CrawlID != 2
            GROUP BY LogTime 
        ORDER BY LogTime
    END
' 
END
GO
