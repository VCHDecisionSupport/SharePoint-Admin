USE [DSSPPROD_UsageAndHealth]
GO
/****** Object:  StoredProcedure [dbo].[Search_GetIndexEngineQueryLatencyAggregated]    Script Date: 11/10/2016 4:16:42 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Search_GetIndexEngineQueryLatencyAggregated]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
     CREATE PROCEDURE [dbo].[Search_GetIndexEngineQueryLatencyAggregated]
        @applicationId uniqueIdentifier,
        @startDate datetime,
        @endDate datetime,
        @applicationTypes ApplicationTypeTableType READONLY,
        @resultPageUrls ResultPageUrlTableType READONLY,
        @imsFlows ImsFlowTableType READONLY,
        @tenantIds TenantIdTableType READONLY,
        @machineNames MachineNameTableType READONLY
    AS
        BEGIN
            SELECT 
                COALESCE(L.LogTime, E.LogTime) as LogTime,
                E.MachineName as MachineName,
                E.NumQueries AS NumQueries,
                E.MsFsQueryLatency AS MsFsQueryLatency,
                L.MsMarsQueryLatency AS MsMarsQueryLatency
            FROM
            (
                SELECT 
                    LogTime as LogTime,
                    MachineName as MachineName,
                    SUM(LookupMs)/ISNULL(NULLIF(SUM(NumLookups),0),1) + SUM(DocSumMs)/ISNULL(NULLIF(SUM(NumDocSums),0),1) AS MsFsQueryLatency,
                    SUM(NumLookups) as NumQueries
                FROM Search_PerMinuteIndexEngineQueryLatency
                WHERE
                (
                    (((SELECT COUNT(*) FROM @applicationTypes) = 0) OR
                     (ApplicationType IN 
                            (SELECT EInner.ApplicationType FROM Search_PerMinuteIndexEngineQueryLatency EInner INNER JOIN @applicationTypes AppType ON EInner.ApplicationType = AppType.ApplicationType)))
                    AND
                    (((SELECT COUNT(*) FROM @resultPageUrls) = 0) OR
                     (ResultPageUrl IN 
                            (SELECT EInner.ResultPageUrl FROM Search_PerMinuteIndexEngineQueryLatency EInner INNER JOIN @resultPageUrls ResUrl ON EInner.ResultPageUrl = ResUrl.ResultPageUrl)))
                    AND
                    (((SELECT COUNT(*) FROM @imsFlows) = 0) OR
                     (ImsFlow IN 
                            (SELECT EInner.ImsFlow FROM Search_PerMinuteIndexEngineQueryLatency EInner INNER JOIN @imsFlows Ims ON EInner.ImsFlow = Ims.ImsFlow)))
                    AND
                    (((SELECT COUNT(*) FROM @tenantIds) = 0) OR
                     (TenantId IN 
                            (SELECT EInner.TenantId FROM Search_PerMinuteIndexEngineQueryLatency EInner INNER JOIN @tenantIds Tenant ON EInner.TenantId = Tenant.TenantId)))
                    AND
                    (((SELECT COUNT(*) FROM @machineNames) = 0) OR
                     (MachineName IN 
                            (SELECT EInner.MachineName FROM Search_PerMinuteIndexEngineQueryLatency EInner INNER JOIN @machineNames Machines ON EInner.MachineName = Machines.MachineName)))
                    AND
                    (@applicationId = ''00000000-0000-0000-0000-000000000000'' OR ApplicationId = @applicationId) 
                    AND
                    LogTime <= @endDate 
                    AND
                    LogTime >= @startDate
                )
                GROUP BY MachineName, LogTime
            ) AS E
            RIGHT JOIN
            (
                SELECT 
                    LogTime as LogTime, 
                    SUM(NumQueries) as NumQueries,
                    SUM(TotalQueryTimeMs)/SUM(NumQueries) AS MsMarsQueryLatency
                FROM Search_PerMinuteIndexLookupQueryLatency
                WHERE
                (
                    (((SELECT COUNT(*) FROM @applicationTypes) = 0) OR
                     (ApplicationType IN 
                            (SELECT LInner.ApplicationType FROM Search_PerMinuteIndexLookupQueryLatency LInner INNER JOIN @applicationTypes AppType ON LInner.ApplicationType = AppType.ApplicationType)))
                    AND
                    (((SELECT COUNT(*) FROM @resultPageUrls) = 0) OR
                     (ResultPageUrl IN 
                            (SELECT LInner.ResultPageUrl FROM Search_PerMinuteIndexLookupQueryLatency LInner INNER JOIN @resultPageUrls ResUrl ON LInner.ResultPageUrl = ResUrl.ResultPageUrl)))
                    AND
                    (((SELECT COUNT(*) FROM @imsFlows) = 0) OR
                     (ImsFlow IN 
                            (SELECT LInner.ImsFlow FROM Search_PerMinuteIndexLookupQueryLatency LInner INNER JOIN @imsFlows Ims ON LInner.ImsFlow = Ims.ImsFlow)))
                    AND
                    (((SELECT COUNT(*) FROM @tenantIds) = 0) OR
                     (TenantId IN 
                            (SELECT LInner.TenantId FROM Search_PerMinuteIndexLookupQueryLatency LInner INNER JOIN @tenantIds Tenant ON LInner.TenantId = Tenant.TenantId)))
                    AND
                    (@applicationId = ''00000000-0000-0000-0000-000000000000'' OR ApplicationId = @applicationId) 
                    AND
                    LogTime <= @endDate 
                    AND
                    LogTime >= @startDate
                )
                GROUP BY LogTime
            ) AS L
            ON E.LogTime = L.LogTime
            ORDER BY LogTime
        END
    ' 
END
GO
