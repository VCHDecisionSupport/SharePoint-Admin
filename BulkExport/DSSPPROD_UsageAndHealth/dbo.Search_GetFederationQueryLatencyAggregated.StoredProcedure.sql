USE [DSSPPROD_UsageAndHealth]
GO
/****** Object:  StoredProcedure [dbo].[Search_GetFederationQueryLatencyAggregated]    Script Date: 11/10/2016 4:16:42 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Search_GetFederationQueryLatencyAggregated]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
        CREATE PROCEDURE [dbo].[Search_GetFederationQueryLatencyAggregated]
            @applicationId uniqueIdentifier,
            @startDate datetime,
            @endDate datetime,
            @applicationTypes ApplicationTypeTableType READONLY,
            @resultPageUrls ResultPageUrlTableType READONLY,
            @imsFlows ImsFlowTableType READONLY,
            @tenantIds TenantIdTableType READONLY,
            @flowNames FlowNameTableType READONLY
        AS
        BEGIN
            SELECT  Flow.FlowName as FlowName, 
                    Flow.LogTime as LogTime,
                    SUM(Flow.TotalTimeMs)/SUM(Flow.NumQueries) As LatencyMs
            FROM Search_PerMinuteFlowLatency Flow
            WHERE
            (
                (((SELECT COUNT(*) FROM @applicationTypes) = 0) OR
                    (Flow.ApplicationType IN 
                        (SELECT FlowInner.ApplicationType FROM Search_PerMinuteFlowLatency FlowInner INNER JOIN @applicationTypes AppType ON FlowInner.ApplicationType = AppType.ApplicationType)))
                AND
                (((SELECT COUNT(*) FROM @resultPageUrls) = 0) OR
                    (Flow.ResultPageUrl IN 
                        (SELECT FlowInner.ResultPageUrl FROM Search_PerMinuteFlowLatency FlowInner INNER JOIN @resultPageUrls ResUrl ON FlowInner.ResultPageUrl = ResUrl.ResultPageUrl)))
                AND
                (((SELECT COUNT(*) FROM @imsFlows) = 0) OR
                    (Flow.ImsFlow IN 
                        (SELECT FlowInner.ImsFlow FROM Search_PerMinuteFlowLatency FlowInner INNER JOIN @imsFlows Ims ON FlowInner.ImsFlow = Ims.ImsFlow)))
                AND
                (((SELECT COUNT(*) FROM @tenantIds) = 0) OR
                    (Flow.TenantId IN 
                        (SELECT FlowInner.TenantId FROM Search_PerMinuteFlowLatency FlowInner INNER JOIN @tenantIds Tenant ON FlowInner.TenantId = Tenant.TenantId)))
                AND
                (((SELECT COUNT(*) FROM @flowNames) = 0) OR
                    (Flow.FlowName IN 
                        (SELECT FlowInner.FlowName FROM Search_PerMinuteFlowLatency FlowInner INNER JOIN @flowNames Flows ON FlowInner.FlowName = Flows.FlowName)))
                AND
                (@applicationId = ''00000000-0000-0000-0000-000000000000'' OR Flow.ApplicationId = @applicationId) 
                AND
                Flow.LogTime <= @endDate 
                AND
                Flow.LogTime >= @startDate
            )
            GROUP BY Flow.FlowName, Flow.LogTime
            ORDER BY Flow.LogTime
        END
    ' 
END
GO
