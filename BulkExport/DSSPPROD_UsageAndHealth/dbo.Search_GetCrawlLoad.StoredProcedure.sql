USE [DSSPPROD_UsageAndHealth]
GO
/****** Object:  StoredProcedure [dbo].[Search_GetCrawlLoad]    Script Date: 11/10/2016 4:16:42 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Search_GetCrawlLoad]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
    CREATE PROCEDURE [dbo].[Search_GetCrawlLoad]
        @startDate datetime,
        @endDate datetime,
        @machineName nvarchar(128)
    AS
    BEGIN
        SELECT
                MAX(LogTime) As LogTime,
                SUM(GathererDelayed) As GathererDelayed,
                SUM(GathererTransactionsBeingFiltered) As GathererTransactionsBeingFiltered,
                SUM(GathererInProgress) As GathererInProgress ,
                SUM(GathererCompleteTransactions) As GathererCompleteTransactions,
                SUM(CTSSubmitted) As CTSSubmitted,
                SUM(WaitingInContentPlugin) As WaitingInPlugin,
                COUNT(*) As TotalCount,
                SUM(NumMachinesInAMinute) As TotalRows 
        FROM 
        (
            SELECT
                MAX(LogTime) As LogTime,
                MachineName,
                AVG(GathererDelayed) AS GathererDelayed,
                AVG(GathererTransactionsBeingFiltered) AS GathererTransactionsBeingFiltered,
                AVG(GathererInProgress) AS GathererInProgress,
                AVG(GathererCompleteTransactions) AS GathererCompleteTransactions,
                AVG(CTSSubmitted) AS CTSSubmitted,
                AVG(WaitingInContentPlugin) AS WaitingInContentPlugin,
                COUNT(*) AS NumMachinesInAMinute
            FROM Search_CrawlLoad
            WHERE
                LogTime <= @EndDate AND
                LogTime >= @StartDate AND
                (@machineName = ''00000000-0000-0000-0000-000000000000'' OR MachineName = @machineName)
            GROUP BY MachineName,
                DATEPART(yy, LogTime),  DATEPART(mm, LogTime),  DATEPART(dd, LogTime), DATEPART(hh, LogTime), DATEPART(mi, LogTime)
        )AS TempTable
        WHERE 
            GathererDelayed < 1000000
            AND GathererTransactionsBeingFiltered < 1000000
            AND GathererInProgress < 1000000
            AND GathererCompleteTransactions < 1000000
            AND CTSSubmitted < 1000000
            AND WaitingInContentPlugin < 1000000
        GROUP BY
            DATEPART(yy, LogTime),  DATEPART(mm, LogTime),  DATEPART(dd, LogTime), DATEPART(hh, LogTime), DATEPART(mi, LogTime)
        ORDER BY LogTime
    END
    ' 
END
GO
