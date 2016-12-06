USE [DSSPPROD_UsageAndHealth]
GO
/****** Object:  StoredProcedure [dbo].[Search_GetFederationQueryLatencyVerbose]    Script Date: 11/10/2016 4:16:42 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Search_GetFederationQueryLatencyVerbose]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
        CREATE PROCEDURE [dbo].[Search_GetFederationQueryLatencyVerbose]
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
                    AVG(Flow.TimeMs) As LatencyMs
            FROM Search_VerboseFlowLatency Flow
            INNER JOIN Search_VerboseQueryTags Tags on Tags.CorrelationId = Flow.CorrelationId
            WHERE (@applicationId = ''00000000-0000-0000-0000-000000000000'' OR Tags.ApplicationId = @applicationId) AND
                  (((SELECT COUNT(*) FROM @flowNames) = 0) OR 
                     (Flow.FlowName IN (SELECT FlowName FROM @flowNames))) AND
                   (((SELECT COUNT(*) FROM @applicationTypes) = 0) OR
                     Tags.ApplicationType IN (SELECT ApplicationType from @applicationTypes)) AND
                   (((SELECT COUNT(*) FROM @imsFlows) = 0) OR
                     Tags.ImsFlow IN (SELECT ImsFlow from @imsFlows)) AND
                   (((SELECT COUNT(*) FROM @resultPageUrls) = 0) OR
                     Tags.ResultPageUrl IN (SELECT ResultPageUrl from @resultPageUrls)) AND
                   (((SELECT COUNT(*) FROM @tenantIds) = 0) OR
                     Tags.TenantId IN (SELECT TenantId from @tenantIds)) AND
                   Tags.LogTime <= @endDate AND
                   Tags.LogTime >= @startDate
            GROUP BY Flow.FlowName, Flow.LogTime
            ORDER BY Flow.LogTime
        END
    ' 
END
GO
