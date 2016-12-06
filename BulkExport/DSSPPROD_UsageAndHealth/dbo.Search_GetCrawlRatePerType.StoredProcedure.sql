USE [DSSPPROD_UsageAndHealth]
GO
/****** Object:  StoredProcedure [dbo].[Search_GetCrawlRatePerType]    Script Date: 11/10/2016 4:16:42 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Search_GetCrawlRatePerType]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
    CREATE PROCEDURE [dbo].[Search_GetCrawlRatePerType]
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
            LogTime,
            (SUM(ActionAddModify) + SUM(ActionNoIndex))/60.0 AS ModifiedTotal,
            (SUM(ActionError))/60.0 AS ErrorTotal,
            (SUM(ActionRetry))/60.0 AS RetryTotal,
            (SUM(ActionDelete))/60.0 AS DeleteTotal,
            (SUM(ActionNotModified))/60.0 AS NotModifiedTotal,
            (SUM(ActionSecurityOnly)/10)/60.0 AS SecurityOnlyTotal
        FROM Search_CrawlDocumentStats
            INNER JOIN ContentSources ON Search_CrawlDocumentStats.ContentSourceId = ContentSources.Id AND Search_CrawlDocumentStats.ApplicationId = ContentSources.AppId
        WHERE (@applicationId = ''00000000-0000-0000-0000-000000000000'' OR ApplicationId = @applicationId) AND
            LogTime >= @StartDate AND
            LogTime <= @EndDate AND
            (@machineName = ''00000000-0000-0000-0000-000000000000'' OR MachineName = @machineName)
        GROUP BY LogTime
        ORDER BY LogTime
    END
' 
END
GO
