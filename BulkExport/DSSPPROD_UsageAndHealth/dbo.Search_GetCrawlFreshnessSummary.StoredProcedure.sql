USE [DSSPPROD_UsageAndHealth]
GO
/****** Object:  StoredProcedure [dbo].[Search_GetCrawlFreshnessSummary]    Script Date: 11/10/2016 4:16:42 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Search_GetCrawlFreshnessSummary]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
        CREATE PROCEDURE [dbo].[Search_GetCrawlFreshnessSummary]
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
        ContentSources.Name AS ContentSourceName,
        ContentSources.Name AS Percentile90th,
        MAX(IsHighPriority),
        SUM( LessThan2Min + LessThan5Min + LessThan10Min + LessThan20Min + LessThan30Min + LessThan45Min + LessThan1Hour + LessThan2Hours + LessThan4Hours + LessThan8Hours + LessThan12Hours + LessThan1Day + LessThan2Days + LessThan3Days ) AS LessThan3Days,
        SUM( LessThan2Min )as Min2,
        SUM( LessThan2Min + LessThan5Min  ) as Min5,
        SUM( LessThan2Min + LessThan5Min + LessThan10Min  ) Min10,
        SUM( LessThan2Min + LessThan5Min + LessThan10Min + LessThan20Min  ) as Min20,
        SUM( LessThan2Min + LessThan5Min + LessThan10Min + LessThan20Min + LessThan30Min ) As Min30,
        SUM( LessThan2Min + LessThan5Min + LessThan10Min + LessThan20Min + LessThan30Min + LessThan45Min  ) AS Min45,
        SUM( LessThan2Min + LessThan5Min + LessThan10Min + LessThan20Min + LessThan30Min + LessThan45Min + LessThan1Hour ) AS Hour1,
        SUM( LessThan2Min + LessThan5Min + LessThan10Min + LessThan20Min + LessThan30Min + LessThan45Min + LessThan1Hour + LessThan2Hours ) AS Hour2,
        SUM( LessThan2Min + LessThan5Min + LessThan10Min + LessThan20Min + LessThan30Min + LessThan45Min + LessThan1Hour + LessThan2Hours + LessThan4Hours )Hour4,
        SUM( LessThan2Min + LessThan5Min + LessThan10Min + LessThan20Min + LessThan30Min + LessThan45Min + LessThan1Hour + LessThan2Hours + LessThan4Hours + LessThan8Hours ) AS Hour8,
        SUM( LessThan2Min + LessThan5Min + LessThan10Min + LessThan20Min + LessThan30Min + LessThan45Min + LessThan1Hour + LessThan2Hours + LessThan4Hours + LessThan8Hours + LessThan12Hours ) AS Hour12,
        SUM( LessThan2Min + LessThan5Min + LessThan10Min + LessThan20Min + LessThan30Min + LessThan45Min + LessThan1Hour + LessThan2Hours + LessThan4Hours + LessThan8Hours + LessThan12Hours + LessThan1Day )  as Day1,
        SUM( LessThan2Min + LessThan5Min + LessThan10Min + LessThan20Min + LessThan30Min + LessThan45Min + LessThan1Hour + LessThan2Hours + LessThan4Hours + LessThan8Hours + LessThan12Hours + LessThan1Day + LessThan2Days )  as Day2,
        SUM( LessThan2Min + LessThan5Min + LessThan10Min + LessThan20Min + LessThan30Min + LessThan45Min + LessThan1Hour + LessThan2Hours + LessThan4Hours + LessThan8Hours + LessThan12Hours + LessThan1Day + LessThan2Days + LessThan3Days )  as Day3,
        SUM( LessThan2Min + LessThan5Min + LessThan10Min + LessThan20Min + LessThan30Min + LessThan45Min + LessThan1Hour + LessThan2Hours + LessThan4Hours + LessThan8Hours + LessThan12Hours + LessThan1Day + LessThan2Days + LessThan3Days + LessThan1Week + LessThan1Month + GreaterThan1Month ) as TotalCount
    FROM Search_CrawlDocumentStats INNER JOIN ContentSources ON Search_CrawlDocumentStats.ContentSourceId = ContentSources.Id AND Search_CrawlDocumentStats.ApplicationId = ContentSources.AppId
    WHERE 
        (@applicationId = ''00000000-0000-0000-0000-000000000000'' OR ApplicationId = @applicationId) AND
        LogTime >= @startDate AND
        LogTime <= @endDate  AND
        ((@crawlType>=2) OR (IsHighPriority = @crawlType)) AND
        CrawlID != 2
    GROUP BY ContentSources.AppId, ContentSources.Id, ContentSources.Name
    HAVING 
        SUM( LessThan2Min + LessThan5Min + LessThan10Min + LessThan20Min + LessThan30Min + LessThan45Min + LessThan1Hour + LessThan2Hours + LessThan4Hours + LessThan8Hours + LessThan12Hours + LessThan1Day + LessThan2Days + LessThan3Days + LessThan1Week + LessThan1Month + GreaterThan1Month ) >0
    ORDER BY MAX(IsHighPriority) DESC, SUM( LessThan2Min + LessThan5Min + LessThan10Min + LessThan20Min + LessThan30Min + LessThan45Min + LessThan1Hour + LessThan2Hours + LessThan4Hours + LessThan8Hours + LessThan12Hours + LessThan1Day + LessThan2Days + LessThan3Days + LessThan1Week + LessThan1Month + GreaterThan1Month ) DESC
    END
' 
END
GO
