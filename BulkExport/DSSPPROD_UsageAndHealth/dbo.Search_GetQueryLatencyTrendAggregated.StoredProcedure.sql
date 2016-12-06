USE [DSSPPROD_UsageAndHealth]
GO
/****** Object:  StoredProcedure [dbo].[Search_GetQueryLatencyTrendAggregated]    Script Date: 11/10/2016 4:16:42 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Search_GetQueryLatencyTrendAggregated]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
    CREATE PROCEDURE [dbo].[Search_GetQueryLatencyTrendAggregated]
        @applicationId uniqueIdentifier,
        @startDate datetime,
        @endDate datetime,
        @applicationTypes ApplicationTypeTableType READONLY,
        @resultPageUrls ResultPageUrlTableType READONLY,
        @imsFlows ImsFlowTableType READONLY,
        @tenantIds TenantIdTableType READONLY
    AS
        ;WITH Pcts AS
        (
            SELECT 0.05 AS pct
            UNION ALL SELECT 0.50
            UNION ALL SELECT 0.70
            UNION ALL SELECT 0.80
            UNION ALL SELECT 0.90
            UNION ALL SELECT 0.95
        ),
        Queries (LogTime, TotalQueryTimeMs, NumQueries) AS
        (
            SELECT LogTime AS LogTime, TotalQueryTimeMs AS TotalQueryTimeMs, NumQueries AS NumQueries
            FROM Search_BucketedOMQueryLatency OM
                WHERE 
                (((SELECT COUNT(*) FROM @applicationTypes) = 0) OR
                    (OM.ApplicationType IN 
                        (SELECT OMInner.ApplicationType FROM Search_BucketedOMQueryLatency OMInner INNER JOIN @applicationTypes AppType ON OMInner.ApplicationType = AppType.ApplicationType)))
                    AND
                (((SELECT COUNT(*) FROM @resultPageUrls) = 0) OR
                    (OM.ResultPageUrl IN 
                        (SELECT OMInner.ResultPageUrl FROM Search_BucketedOMQueryLatency OMInner INNER JOIN @resultPageUrls ResUrl ON OMInner.ResultPageUrl = ResUrl.ResultPageUrl)))
                AND
                (((SELECT COUNT(*) FROM @imsFlows) = 0) OR
                    (OM.ImsFlow IN 
                        (SELECT OMInner.ImsFlow FROM Search_BucketedOMQueryLatency OMInner INNER JOIN @imsFlows Ims ON OMInner.ImsFlow = Ims.ImsFlow)))
                AND
                (((SELECT COUNT(*) FROM @tenantIds) = 0) OR
                    (OM.TenantId IN 
                        (SELECT OMInner.TenantId FROM Search_BucketedOMQueryLatency OMInner INNER JOIN @tenantIds Tenant ON OMInner.TenantId = Tenant.TenantId)))
                AND
               (@applicationId = ''00000000-0000-0000-0000-000000000000'' OR ApplicationId = @applicationId) AND
                LogTime > @StartDate AND LogTime < @EndDate
                AND TotalQueryTimeMs > 0
        ),
        CountQueries (cnt, LogTimeYear, LogTimeDay, LogTimeHour) AS
        (
            SELECT SUM(NumQueries) AS cnt, DATEPART(YEAR, LogTime), DATEPART(DAYOFYEAR, LogTime),  DATEPART(HOUR, LogTime) 
            FROM Queries
            GROUP BY DATEPART(YEAR, LogTime), DATEPART(DAYOFYEAR, LogTime), DATEPART(HOUR, LogTime)
        ),
        PctCount_n AS
        (
            SELECT pct, cnt, pct * (cnt - 1) + 1 AS n, LogTimeYear, LogTimeDay, LogTimeHour
            FROM PCTs
            CROSS JOIN CountQueries
        ),
        PctCount_ndk AS
        (
            SELECT pct, cnt, n, CAST(n AS INT) AS k, n - CAST(n AS INT) AS d, LogTimeYear, LogTimeDay, LogTimeHour
            FROM PctCount_n
        ),
        Latency AS
        (
            SELECT TotalQueryTimeMs AS MsSpentTotal, 
                   SUM(NumQueries) as TotalNumQueries,
                   DATEPART(YEAR, LogTime) AS LogTimeYear,  
                   DATEPART(DAYOFYEAR, LogTime) AS LogTimeDay,  
                   DATEPART(HOUR, LogTime) AS LogTimeHour
            FROM Queries
            GROUP BY DATEPART(YEAR, LogTime), DATEPART(DAYOFYEAR, LogTime), DATEPART(HOUR, LogTime), TotalQueryTimeMs
        ),
        QueriesRn AS
        (
            SELECT 
                ROW_NUMBER() OVER
                (
                    PARTITION BY LogTimeYear, LogTimeDay, LogTimeHour ORDER BY MsSpentTotal
                ) AS rn,
                LogTimeYear,
                LogTimeDay,
                LogTimeHour,
                MsSpentTotal,
                TotalNumQueries
            FROM Latency
        ),
        CumulativeQueriesRn AS
        (
            SELECT q1.TotalNumQueries AS rn,
                   q1.LogTimeYear AS LogTimeYear, 
                   q1.LogTimeDay AS LogTimeDay,
                   q1.LogTimeHour AS LogTimeHour, 
                   q1.MsSpentTotal AS MsSpentTotal,
                   SUM(q2.TotalNumQueries) AS rn_cumulative 
            FROM QueriesRn q1
            CROSS JOIN QueriesRn q2 
            WHERE (q2.rn <= q1.rn AND
                   q1.LogTimeYear = q2.LogTimeYear AND 
                   q1.LogTimeDay = q2.LogTimeDay AND 
                   q1.LogTimeHour = q2.LogTimeHour)
            GROUP BY q1.LogTimeYear, q1.LogTimeDay, q1.LogTimeHour, q1.rn, q1.MsSpentTotal, q1.TotalNumQueries
        ),
        CrawlRate AS
        (
            SELECT CAST((SUM(ActionAddModify + ActionNoIndex + ActionDelete + ActionRetry) + SUM(ActionSecurityOnly)/10)/3600 AS INT) AS DPS, DATEPART(YEAR, LogTime) AS LogTimeYear, DATEPART(DAYOFYEAR, LogTime) AS LogTimeDay, DATEPART(HOUR, LogTime) as LogTimeHour 
            FROM Search_CrawlDocumentStats
            WHERE LogTime > @startDate AND LogTime < @endDate and (@applicationId = ''00000000-0000-0000-0000-000000000000'' OR ApplicationId = @applicationId)
            GROUP BY DATEPART(YEAR, LogTime), DATEPART(DAYOFYEAR, LogTime), DATEPART(HOUR, LogTime)
        ),
        AnalyticsPURate AS
        (
            SELECT CAST(SUM(PartialUpdates)/3600 AS INT) AS PUPS, DATEPART(YEAR, LogTime) AS LogTimeYear, DATEPART(DAYOFYEAR, LogTime) AS LogTimeDay, DATEPART(HOUR, LogTime) as LogTimeHour 
            FROM Search_PerMinuteFeedRate
            WHERE
            (
                LogTime > @startDate
                AND LogTime < @endDate
                AND (@applicationId = ''00000000-0000-0000-0000-000000000000'' OR ApplicationId = @applicationId)
                AND (FlowName = ''Microsoft.PeopleAnalyticsOutputFlow'' OR FlowName = ''Microsoft.SearchAnalyticsOutputFlow'' OR FlowName = ''Microsoft.UsageAnalyticsFeederFlow'')
            )
            GROUP BY DATEPART(YEAR, LogTime), DATEPART(DAYOFYEAR, LogTime), DATEPART(HOUR, LogTime)
        ),
        JoinedCrawlAnalyticsRate AS
        (
            SELECT SUM(DPS) AS DPS, SUM(PUPS) AS PUPS, LogTimeYear, LogTimeDay, LogTimeHour
            FROM
            (
                SELECT DPS, 0 AS PUPS, LogTimeYear, LogTimeDay, LogTimeHour 
                FROM CrawlRate
                UNION
                SELECT 0 AS DPS, PUPS, LogTimeYear, LogTimeDay, LogTimeHour
                FROM AnalyticsPURate AS apus
                GROUP BY LogTimeYear, LogTimeDay, LogTimeHour, PUPS
            ) tmp
            GROUP BY LogTimeYear, LogTimeDay, LogTimeHour
        ),
        NormalizeFactor AS
        (
            SELECT CAST(MAX(PUPS)/NULLIF(MAX(DPS),0) AS INT) AS SuggestedNormFactor FROM JoinedCrawlAnalyticsRate
        ),
        FeedRate AS
        (
            SELECT N.SuggestedNormFactor, J.DPS, J.PUPS, J.LogTimeYear, J.LogTimeHour, J.LogTimeDay
            FROM NormalizeFactor N 
            CROSS JOIN
            JoinedCrawlAnalyticsRate J
        )
        SELECT LogTime, DPS, PUPS, SuggestedNormFactor, [5] AS Percentile_5, [50] AS Percentile_50, [70] AS Percentile_70, [80] AS Percentile_80, [90] AS Percentile_90, [95] AS Percentile_95
        FROM 
        (
            SELECT 
                CAST(ROUND(pct* 100, 0) AS INT) AS Percentile,
                MIN(MsSpentTotal) + d * (MAX(MsSpentTotal) - MIN(MsSpentTotal)) AS Latency,
                DATEADD(YEAR, COALESCE(m.LogTimeYear, fr.LogTimeYear) - DATEPART(YEAR, @startDate), DATEADD(DAYOFYEAR, COALESCE(m.LogTimeDay, fr.LogTimeDay) - DATEPART(DAYOFYEAR, @startDate), DATEADD(HOUR, COALESCE(m.LogTimeHour, fr.LogTimeHour) - DATEPART(HOUR, @startDate), @startDate))) AS LogTime,
                fr.DPS, fr.PUPS, fr.SuggestedNormFactor
            FROM PctCount_ndk AS P
            LEFT OUTER JOIN CumulativeQueriesRn AS M ON 
                ((d = 0.00 AND k = cnt AND rn_cumulative = k)
                OR (d > 0.00 AND k = cnt AND rn_cumulative IN(k, k-1))
                OR (d >= 0.00 AND k < cnt AND k <= rn_cumulative AND k >= (rn_cumulative - rn)))
                AND p.LogTimeYear = m.LogTimeYear 
                AND p.LogTimeDay = m.LogTimeDay 
                AND p.LogTimeHour = m.LogTimeHour
            FULL OUTER JOIN FeedRate fr ON 
                p.LogTimeYear = fr.LogTimeYear
                AND p.LogTimeDay = fr.LogTimeDay 
                AND p.LogTimeHour = fr.LogTimeHour
            GROUP BY pct, k, d, m.LogTimeYear, m.LogTimeDay, m.LogTimeHour, fr.LogTimeYear, fr.LogTimeDay, fr.LogTimeHour, fr.DPS, fr.PUPS, fr.SuggestedNormFactor
        ) p
        PIVOT
        (
            SUM(p.Latency) 
            FOR Percentile IN
            ( [5], [50], [70], [80], [90], [95])
        ) AS pvt
        GROUP BY LogTime, DPS, PUPS, SuggestedNormFactor, [5], [50], [70], [80], [90], [95]
        ORDER BY LogTime;
' 
END
GO
