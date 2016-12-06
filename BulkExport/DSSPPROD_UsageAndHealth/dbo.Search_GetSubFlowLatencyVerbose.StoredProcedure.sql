USE [DSSPPROD_UsageAndHealth]
GO
/****** Object:  StoredProcedure [dbo].[Search_GetSubFlowLatencyVerbose]    Script Date: 11/10/2016 4:16:42 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Search_GetSubFlowLatencyVerbose]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
        CREATE PROCEDURE [dbo].[Search_GetSubFlowLatencyVerbose]
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
                    F.LogTime, 
                    AVG(F.TimeMs), 
                    COUNT(F.LogTime)
                FROM 
                    Search_VerboseFlowLatency F
                INNER JOIN Search_VerboseQueryTags Tags 
                  ON Tags.CorrelationId = F.CorrelationId
                WHERE 
                (
                    (((SELECT COUNT(*) FROM @applicationTypes) = 0) OR
                        Tags.ApplicationType IN (SELECT ApplicationType from @applicationTypes)) 
                    AND
                    (((SELECT COUNT(*) FROM @imsFlows) = 0) OR
                        Tags.ImsFlow IN (SELECT ImsFlow from @imsFlows)) 
                    AND
                    (((SELECT COUNT(*) FROM @resultPageUrls) = 0) OR
                        Tags.ResultPageUrl IN (SELECT ResultPageUrl from @resultPageUrls))
                    AND
                    (((SELECT COUNT(*) FROM @tenantIds) = 0) OR
                        Tags.TenantId IN (SELECT TenantId from @tenantIds))
                    AND
                    (@applicationId = ''00000000-0000-0000-0000-000000000000'' OR Tags.ApplicationId = @applicationId)
                    AND
                    F.LogTime <= @endDate 
                    AND
                    F.LogTime >= @startDate
                    AND
                    F.FlowName = @parentFlow
                )
                GROUP BY F.LogTime
            ),
            SubFlow(LogTime, SubFlowName, Latency, NumQueries) AS
            (
                SELECT 
                    S.LogTime, 
                    S.SubFlow, 
                    AVG(S.SubFlowTimeMs), 
                    COUNT(S.LogTime)
                FROM 
                    Search_VerboseQuerySubFlowTimings S
                INNER JOIN Search_VerboseQueryTags Tags 
                  ON Tags.CorrelationId = S.CorrelationId
                WHERE
                (
                    (((SELECT COUNT(*) FROM @applicationTypes) = 0) OR
                        Tags.ApplicationType IN (SELECT ApplicationType from @applicationTypes)) 
                    AND
                    (((SELECT COUNT(*) FROM @imsFlows) = 0) OR
                        Tags.ImsFlow IN (SELECT ImsFlow from @imsFlows)) 
                    AND
                    (((SELECT COUNT(*) FROM @resultPageUrls) = 0) OR
                        Tags.ResultPageUrl IN (SELECT ResultPageUrl from @resultPageUrls))
                    AND
                    (((SELECT COUNT(*) FROM @tenantIds) = 0) OR
                        Tags.TenantId IN (SELECT TenantId from @tenantIds))
                    AND
                    (@applicationId = ''00000000-0000-0000-0000-000000000000'' OR Tags.ApplicationId = @applicationId)
                    AND
                    S.LogTime <= @endDate 
                    AND
                    S.LogTime >= @startDate
                    AND
                    S.ParentFlow = @parentFlow
                )
                GROUP BY S.SubFlow, S.LogTime
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
