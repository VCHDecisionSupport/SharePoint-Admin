USE [DSSPPROD_UsageAndHealth]
GO
/****** Object:  StoredProcedure [dbo].[Search_GetQueryLatencyTrendVerbose]    Script Date: 11/10/2016 4:16:42 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Search_GetQueryLatencyTrendVerbose]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
    CREATE PROCEDURE [dbo].[Search_GetQueryLatencyTrendVerbose]
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
        CountQueries (cnt, LogTimeYear, LogTimeDay, LogTimeHour) AS
        (
            SELECT COUNT(*) AS cnt, DATEPART(YEAR, OM.LogTime),  DATEPART(DAYOFYEAR, OM.LogTime),  DATEPART(HOUR, OM.LogTime) 
            FROM Search_VerboseOMQueryLatency OM
            INNER JOIN Search_VerboseQueryTags Tags on Tags.CorrelationId = OM.CorrelationId
            WHERE (@applicationId = ''00000000-0000-0000-0000-000000000000'' OR Tags.ApplicationId = @applicationId) AND 
                Tags.LogTime > @StartDate AND Tags.LogTime < @EndDate AND
                (((SELECT COUNT(*) FROM @applicationTypes) = 0) OR
                    Tags.ApplicationType IN (SELECT ApplicationType from @applicationTypes)) AND
                (((SELECT COUNT(*) FROM @imsFlows) = 0) OR
                    Tags.ImsFlow IN (SELECT ImsFlow from @imsFlows)) AND
                (((SELECT COUNT(*) FROM @resultPageUrls) = 0) OR
                    Tags.ResultPageUrl IN (SELECT ResultPageUrl from @resultPageUrls)) AND
                (((SELECT COUNT(*) FROM @tenantIds) = 0) OR
                    Tags.TenantId IN (SELECT TenantId from @tenantIds)) AND
                TotalQueryTimeMs > 0
            GROUP BY DATEPART(YEAR, OM.LogTime), DATEPART(DAYOFYEAR, OM.LogTime), DATEPART(HOUR, OM.LogTime)
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
            SELECT TotalQueryTimeMs AS MsSpentTotal, OM.LogTime
            FROM Search_VerboseOMQueryLatency OM
            INNER JOIN Search_VerboseQueryTags Tags on Tags.CorrelationId = OM.CorrelationId
            WHERE (@applicationId = ''00000000-0000-0000-0000-000000000000'' OR Tags.ApplicationId = @applicationId) 
                AND Tags.LogTime > @StartDate AND Tags.LogTime < @EndDate AND
                (((SELECT COUNT(*) FROM @applicationTypes) = 0) OR
                    Tags.ApplicationType IN (SELECT ApplicationType from @applicationTypes)) AND
                (((SELECT COUNT(*) FROM @imsFlows) = 0) OR
                    Tags.ImsFlow IN (SELECT ImsFlow from @imsFlows)) AND
                (((SELECT COUNT(*) FROM @resultPageUrls) = 0) OR
                    Tags.ResultPageUrl IN (SELECT ResultPageUrl from @resultPageUrls)) AND
                (((SELECT COUNT(*) FROM @tenantIds) = 0) OR
                    Tags.TenantId IN (SELECT TenantId from @tenantIds)) AND
                TotalQueryTimeMs > 0
        ),
        QueriesRn AS
        (
            SELECT 
                ROW_NUMBER() OVER
                (
                    PARTITION BY DATEPART(YEAR, LogTime), DATEPART(DAYOFYEAR, LogTime),  DATEPART(HOUR, LogTime) ORDER BY MsSpentTotal
                ) AS rn, 
                DATEPART(YEAR, LogTime) AS LogTimeYear, 
                DATEPART(DAYOFYEAR, LogTime) AS LogTimeDay,  
                DATEPART(HOUR, LogTime) AS LogTimeHour,  
                MsSpentTotal
            FROM Latency
        ),
        CrawlRate AS
        (
            SELECT CAST((SUM(ActionAddModify + ActionNoIndex + ActionDelete + ActionRetry) + SUM(ActionSecurityOnly)/10) /3600 AS INT) AS DPS, DATEPART(YEAR, LogTime) AS LogTimeYear, DATEPART(DAYOFYEAR, LogTime) AS LogTimeDay, DATEPART(HOUR, LogTime) as LogTimeHour 
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
            LEFT OUTER JOIN QueriesRn AS M ON 
                ((d = 0.00 AND rn = k)
                OR (d > 0.00 AND k = cnt AND rn IN(k, k-1))
                OR (d > 0.00 AND k < cnt AND rn IN(k, k+1)))
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
