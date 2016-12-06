USE [DSSPPROD_UsageAndHealth]
GO
/****** Object:  StoredProcedure [dbo].[Search_GetHighPriorityTransactions]    Script Date: 11/10/2016 4:16:42 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Search_GetHighPriorityTransactions]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE [dbo].[Search_GetHighPriorityTransactions]
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
            ISNULL((SUM(SQLTime)/NULLIF(SUM(NumDocuments),0)),0) As SQLTimeAvg,
            ISNULL((SUM(CTSTime)/NULLIF(SUM(NumDocuments),0)),0) As CTSTimeAvg,
            CASE WHEN (SUM(GathererTime)-SUM(CTSTime)-SUM(SQLTime)-SUM(ProtocolHandlerTime))<0
                THEN 0 
            ELSE 
                ISNULL(((SUM(GathererTime)-SUM(CTSTime)-SUM(SQLTime)-SUM(ProtocolHandlerTime))/NULLIF(SUM(NumDocuments),0)),0) 
            END AS GathererTimeAvg,
            ISNULL(((SUM(RepositoryTime + ThreadWaitingTime)/NULLIF(SUM(NumDocuments),0))),0) As RepositoryTimeAvg,
            CASE WHEN (SUM(ProtocolHandlerTime)-SUM(RepositoryTime)-SUM(ThreadWaitingTime))<0
                THEN 0 
            ELSE 
                ISNULL(((SUM(ProtocolHandlerTime)-SUM(RepositoryTime)-SUM(ThreadWaitingTime))/NULLIF(SUM(NumDocuments),0)),0) 
            END AS ProtocolHandlerTimeAvg,
            ISNULL((SUM(TimeSpentInQueue)/NULLIF(SUM(NumDocuments),0)),0) As TimeSpentInQueueAvg,
            ISNULL((SUM(TimeSpentInLinksTable)/NULLIF(SUM(NumDocuments),0)),0) As TimeSpentInLinksTableAvg,
            ISNULL((SUM(DiscoveryTime)/NULLIF(SUM(NumDocuments),0)),0) As DiscoveryTimeAvg,
            MAX(LogTime) As LogTime
        FROM Search_CrawlDocumentStats
            INNER JOIN ContentSources ON Search_CrawlDocumentStats.ContentSourceId = ContentSources.Id AND Search_CrawlDocumentStats.ApplicationId = ContentSources.AppId
        WHERE 
            (@applicationId = ''00000000-0000-0000-0000-000000000000'' OR ApplicationId = @applicationId) AND
            LogTime <= @endDate AND
            LogTime >= @startDate  AND
            IsHighPriority = 1 AND
            CrawlId = 1 AND
            (@machineName = ''00000000-0000-0000-0000-000000000000'' OR MachineName = @machineName)
        GROUP BY
            DATEPART(yy, LogTime),  DATEPART(mm, LogTime),  DATEPART(dd, LogTime), DATEPART(hh, LogTime), DATEPART(mi, LogTime)
    END
' 
END
GO
