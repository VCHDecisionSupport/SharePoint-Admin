USE [DSSPPROD_UsageAndHealth]
GO
/****** Object:  StoredProcedure [dbo].[Search_GetCrawlRatePerContentSourceSummary]    Script Date: 11/10/2016 4:16:42 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Search_GetCrawlRatePerContentSourceSummary]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
    CREATE PROCEDURE [dbo].[Search_GetCrawlRatePerContentSourceSummary]
        @contentSources xml,
        @applicationId uniqueIdentifier,
        @startDate datetime,
        @endDate datetime,
        @machineName nvarchar(128)
    AS
    BEGIN
        IF EXISTS (SELECT * FROM sys.tables WHERE name LIKE ''#MyTempTable%'')
            DROP TABLE #MyTempTable;

        WITH ContentSources(Id, AppId, AppName, Name) AS
        (
            SELECT nref.value(''@id'', ''int'') Id,
                   nref.value(''@appid'', ''uniqueidentifier'') AppId,
                   nref.value(''@appname'', ''nvarchar(100)'') [AppName],
                   nref.value(''@name'', ''nvarchar(100)'') [Name]
            FROM   @contentSources.nodes(''//ContentSources/ContentSource'') AS R(nref)
        )
    
        SELECT 
            ContentSourceName,
            CrawlID,
            SUM(NumDocuments) As DocsCommitted,
            CASE WHEN (CRAWLID)<5
                THEN COUNT(*)
            ELSE 
                DATEDIFF(minute, MIN(LogTime), MAX(LogTime)) + 1
            END AS Duration
        INTO #MyTempTable
        FROM Search_CrawlDocumentStats 
            INNER JOIN ContentSources ON Search_CrawlDocumentStats.ContentSourceId = ContentSources.Id AND Search_CrawlDocumentStats.ApplicationId = ContentSources.AppId
        WHERE (@applicationId = ''00000000-0000-0000-0000-000000000000'' OR ApplicationId = @applicationId) AND
            LogTime >= @startDate AND
            LogTime <= @endDate AND
            (@machineName = ''00000000-0000-0000-0000-000000000000'' OR MachineName = @machineName)
        GROUP BY ContentSourceName, CrawlID
        ORDER BY ContentSourceName

        SELECT  ContentSourceName,
                ISNULL(((SUM(DocsCommitted))/NULLIF(SUM(Duration),0)),0) AS CrawlRate
        FROM #MyTempTable
        GROUP BY ContentSourceName
        ORDER BY ContentSourceName
    END
' 
END
GO
