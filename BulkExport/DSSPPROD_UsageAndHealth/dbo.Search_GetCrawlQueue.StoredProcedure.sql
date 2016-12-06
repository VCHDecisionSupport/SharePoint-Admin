USE [DSSPPROD_UsageAndHealth]
GO
/****** Object:  StoredProcedure [dbo].[Search_GetCrawlQueue]    Script Date: 11/10/2016 4:16:42 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Search_GetCrawlQueue]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
    CREATE PROCEDURE [dbo].[Search_GetCrawlQueue]
        @applicationId uniqueIdentifier,
        @startDate datetime,
        @endDate datetime,
        @dbComponent uniqueIdentifier
    AS
        SELECT 
            LogTime,
            SUM(TransactionsQueued) AS TransactionsQueuedTotal,
            SUM(LinksToBeProcessed) AS LinksToBeProcessedTotal
        FROM Search_CrawlProgress
        WHERE   LogTime <= @EndDate AND
                LogTime >=  @StartDate AND
                (@applicationId = ''00000000-0000-0000-0000-000000000000'' OR ApplicationId = @applicationId) AND
                (@dbComponent =''00000000-0000-0000-0000-000000000000'' OR DBComponent = @dbComponent)
        GROUP BY LogTime
        ORDER BY LogTime
' 
END
GO
