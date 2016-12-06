USE [DSSPPROD_UsageAndHealth]
GO
/****** Object:  StoredProcedure [dbo].[Search_GetCrawlRatePerContentSource]    Script Date: 11/10/2016 4:16:42 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Search_GetCrawlRatePerContentSource]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
    CREATE PROCEDURE [dbo].[Search_GetCrawlRatePerContentSource]
        @contentSources xml,
        @applicationId uniqueIdentifier,
        @startDate datetime,
        @endDate datetime,
        @machineName nvarchar(128)
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
            ContentSources.AppId AS SSAId,
            ContentSources.Id AS CSId,
            LogTime, 
            (SUM(ActionAddModify + ActionNoIndex + ActionDelete + ActionRetry) + SUM(ActionSecurityOnly)/10)/60.0 as NumDocumentsTotal
        FROM Search_CrawlDocumentStats INNER JOIN ContentSources ON Search_CrawlDocumentStats.ContentSourceId = ContentSources.Id AND Search_CrawlDocumentStats.ApplicationId = ContentSources.AppId
        WHERE (@applicationId = ''00000000-0000-0000-0000-000000000000'' OR ApplicationId = @applicationId) AND
            LogTime >= @startDate AND
            LogTime <= @endDate AND
            (@machineName = ''00000000-0000-0000-0000-000000000000'' OR MachineName = @machineName)
        GROUP BY ContentSources.AppId, ContentSources.Id, ContentSources.Name, LogTime
        ORDER BY LogTime
    END
' 
END
GO
