USE [DSSPPROD_UsageAndHealth]
GO
/****** Object:  StoredProcedure [dbo].[Search_GetSubFlowLatencyAggregated]    Script Date: 11/10/2016 4:16:42 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Search_GetSubFlowLatencyAggregated]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
        CREATE PROCEDURE [dbo].[Search_GetSubFlowLatencyAggregated]
            @applicationId uniqueIdentifier,
            @startDate datetime,
            @endDate datetime,
            @applicationTypes ApplicationTypeTableType READONLY,
            @resultPageUrls ResultPageUrlTableType READONLY,
            @imsFlows ImsFlowTableType READONLY,
            @tenantIds TenantIdTableType READONLY,
            @parentFlow nvarchar(256)
        AS
        BEGIN
            WITH
            Flow(LogTime, Latency, NumQueries) AS
            (
                SELECT 
                    LogTime, 
                    SUM(TotalTimeMs)/SUM(NumQueries), 
                    SUM(NumQueries)
                FROM 
                    Search_PerMinuteFlowLatency
                WHERE
                (
                    (((SELECT COUNT(*) FROM @applicationTypes) = 0) OR
                        (ApplicationType IN 
                            (SELECT FlowInner.ApplicationType FROM Search_PerMinuteFlowLatency FlowInner INNER JOIN @applicationTypes AppType ON FlowInner.ApplicationType = AppType.ApplicationType)))
                    AND
                    (((SELECT COUNT(*) FROM @resultPageUrls) = 0) OR
                        (ResultPageUrl IN 
                            (SELECT FlowInner.ResultPageUrl FROM Search_PerMinuteFlowLatency FlowInner INNER JOIN @resultPageUrls ResUrl ON FlowInner.ResultPageUrl = ResUrl.ResultPageUrl)))
                    AND
                    (((SELECT COUNT(*) FROM @imsFlows) = 0) OR
                        (ImsFlow IN 
                            (SELECT FlowInner.ImsFlow FROM Search_PerMinuteFlowLatency FlowInner INNER JOIN @imsFlows Ims ON FlowInner.ImsFlow = Ims.ImsFlow)))
                    AND
                    (((SELECT COUNT(*) FROM @tenantIds) = 0) OR
                        (TenantId IN 
                            (SELECT FlowInner.TenantId FROM Search_PerMinuteFlowLatency FlowInner INNER JOIN @tenantIds Tenant ON FlowInner.TenantId = Tenant.TenantId)))
                    AND
                    (@applicationId = ''00000000-0000-0000-0000-000000000000'' OR ApplicationId = @applicationId)
                    AND
                    LogTime <= @endDate 
                    AND
                    LogTime >= @startDate
                    AND
                    FlowName = @parentFlow
                )
                GROUP BY LogTime
            ),
            SubFlow(LogTime, SubFlowName, Latency, NumQueries) AS
            (
                SELECT 
                    LogTime, 
                    SubFlow, 
                    SUM(SubFlowTimeMs)/SUM(NoOfExecutions), 
                    SUM(NoOfExecutions)
                FROM 
                    Search_PerMinuteQuerySubFlowTimings
                WHERE
                (
                    (((SELECT COUNT(*) FROM @applicationTypes) = 0) OR
                        (ApplicationType IN 
                            (SELECT FlowInner.ApplicationType FROM Search_PerMinuteQuerySubFlowTimings FlowInner INNER JOIN @applicationTypes AppType ON FlowInner.ApplicationType = AppType.ApplicationType)))
                    AND
                    (((SELECT COUNT(*) FROM @resultPageUrls) = 0) OR
                        (ResultPageUrl IN 
                            (SELECT FlowInner.ResultPageUrl FROM Search_PerMinuteQuerySubFlowTimings FlowInner INNER JOIN @resultPageUrls ResUrl ON FlowInner.ResultPageUrl = ResUrl.ResultPageUrl)))
                    AND
                    (((SELECT COUNT(*) FROM @imsFlows) = 0) OR
                        (ImsFlow IN 
                            (SELECT FlowInner.ImsFlow FROM Search_PerMinuteQuerySubFlowTimings FlowInner INNER JOIN @imsFlows Ims ON FlowInner.ImsFlow = Ims.ImsFlow)))
                    AND
                    (((SELECT COUNT(*) FROM @tenantIds) = 0) OR
                        (TenantId IN 
                            (SELECT FlowInner.TenantId FROM Search_PerMinuteQuerySubFlowTimings FlowInner INNER JOIN @tenantIds Tenant ON FlowInner.TenantId = Tenant.TenantId)))
                    AND
                    (@applicationId = ''00000000-0000-0000-0000-000000000000'' OR ApplicationId = @applicationId)
                    AND
                    LogTime <= @endDate 
                    AND
                    LogTime >= @startDate
                    AND
                    ParentFlow = @parentFlow
                )
                GROUP BY SubFlow, LogTime
            )
            (
                SELECT 
                    SubFlow.LogTime as LogTime,
                    SubFlow.SubFlowName as SubFlowName,
                    SubFlow.Latency as LatencyMs,
                    Flow.NumQueries as NumQueries
                FROM SubFlow
                INNER JOIN Flow
                ON Flow.LogTime = SubFlow.LogTime
            )
            UNION ALL
            (
                SELECT
                    Flow.LogTime as LogTime,
                    ''Other'' as SubFlowName,
                    CASE WHEN (AVG(Flow.Latency) - SUM(SubFlow.Latency)) < 0 THEN 0 ELSE (AVG(Flow.Latency) - SUM(SubFlow.Latency)) END as LatencyMs,
                    AVG(Flow.NumQueries) as NumQueries
                FROM Flow
                INNER JOIN SubFlow
                ON Flow.LogTime = SubFlow.LogTime
                GROUP BY Flow.LogTime
            )
            ORDER BY LogTime
        END
    ' 
END
GO
