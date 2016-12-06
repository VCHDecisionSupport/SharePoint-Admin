USE [DSSPPROD_UsageAndHealth]
GO
/****** Object:  StoredProcedure [dbo].[Search_GetCrawlRatePerTypeSummary]    Script Date: 11/10/2016 4:16:42 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Search_GetCrawlRatePerTypeSummary]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
    CREATE PROCEDURE [dbo].[Search_GetCrawlRatePerTypeSummary]
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
            (SUM(ActionAddModify + ActionNoIndex + ActionDelete + ActionRetry ) + SUM(ActionSecurityOnly)/10) / (DATEDIFF(minute, MIN(LogTime), MAX(LogTime)) + 1) AS CrawlRate,
            SUM(NumDocuments) AS ItemsTotal,
            SUM(ActionAddModify) + SUM(ActionNoIndex) AS AddedModifiedTotal,
            SUM(ActionDelete) AS DeletedTotal,
            SUM(ActionNotModified) AS NotModifiedTotal,
            SUM(ActionSecurityOnly) AS SecurityOnlyTotal,
            SUM(ActionError) AS ErrorTotal,
            SUM(ActionRetry) AS RetryTotal
        FROM Search_CrawlDocumentStats
            INNER JOIN ContentSources ON Search_CrawlDocumentStats.ContentSourceId = ContentSources.Id AND Search_CrawlDocumentStats.ApplicationId = ContentSources.AppId
        WHERE (@applicationId = ''00000000-0000-0000-0000-000000000000'' OR ApplicationId = @applicationId) AND
            LogTime >= @StartDate AND
            LogTime <= @EndDate AND
            (@machineName = ''00000000-0000-0000-0000-000000000000'' OR MachineName = @machineName)
    END
' 
END
GO
