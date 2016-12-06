USE [DSSPPROD_UsageAndHealth]
GO
/****** Object:  StoredProcedure [dbo].[Search_GetCrawlLatencySummary]    Script Date: 11/10/2016 4:16:42 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Search_GetCrawlLatencySummary]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
    CREATE PROCEDURE [dbo].[Search_GetCrawlLatencySummary]
        @contentSources xml,
        @applicationId uniqueIdentifier,
        @startDate datetime,
        @endDate datetime,
        @machineName nvarchar(128)
    AS
    BEGIN
        WITH ContentSources(Id, AppId, AppName, Name) AS
        (
            SELECT nref.value(''@id'', ''int'') Id,
                   nref.value(''@appid'', ''uniqueidentifier'') AppId,
                   nref.value(''@appname'', ''nvarchar(100)'') [AppName],
                   nref.value(''@name'', ''nvarchar(100)'') [Name]
            FROM   @contentSources.nodes(''//ContentSources/ContentSource'') AS R(nref)
        )
        SELECT 
            ContentSources.Name AS ContentSourceName, 
            CASE WHEN SUM(GathererTime-CTSTime-SQLTime-ProtocolHandlerTime)<0
                THEN 0 
                ELSE 
                    ISNULL((SUM(GathererTime-CTSTime-SQLTime-ProtocolHandlerTime)/NULLIF(SUM(NumDocuments),0)),0)
                END AS AvgGathererTime,
            ISNULL((SUM(SQLTime)/NULLIF(SUM(NumDocuments),0)),0) AS AvgSQLTime,
            ISNULL((SUM(CTSTimeFromContentPipeline)/NULLIF(SUM(NumDocuments),0)),0) AS AvgCTSTime,
            ISNULL((SUM(IndexerTimeFromContentPipeline)/NULLIF(SUM(NumDocuments),0)),0) As AvgIndexerTime,
            ISNULL(((SUM(RepositoryTime)+SUM(ThreadWaitingTime))/NULLIF(SUM(NumDocuments),0)),0) AS AvgRepositoryTime
        FROM Search_CrawlDocumentStats 
            INNER JOIN ContentSources ON Search_CrawlDocumentStats.ContentSourceId = ContentSources.Id AND Search_CrawlDocumentStats.ApplicationId = ContentSources.AppId
        WHERE (@applicationId = ''00000000-0000-0000-0000-000000000000'' OR ApplicationId = @applicationId) AND
            LogTime >= @startDate AND
            LogTime <= @endDate AND
            (@machineName = ''00000000-0000-0000-0000-000000000000'' OR MachineName = @machineName)
        GROUP BY ContentSources.Name
        ORDER BY MIN(LogTime)
    END
' 
END
GO
