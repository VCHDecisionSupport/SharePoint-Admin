USE [DSSPPROD_UsageAndHealth]
GO
/****** Object:  StoredProcedure [dbo].[Search_GetQueryLatencyAggregated]    Script Date: 11/10/2016 4:16:42 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Search_GetQueryLatencyAggregated]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
     CREATE PROCEDURE [dbo].[Search_GetQueryLatencyAggregated]
       @applicationId uniqueIdentifier,
        @startDate datetime,
        @endDate datetime,
        @applicationTypes ApplicationTypeTableType READONLY,
        @resultPageUrls ResultPageUrlTableType READONLY,
        @imsFlows ImsFlowTableType READONLY,
        @tenantIds TenantIdTableType READONLY
    AS
        BEGIN
            SELECT 
                LogTime as LogTime, 
                SUM(NumQueries) AS NumQueries,
                SUM(QPTimeMs)/SUM(NumQueries) AS MsBackend,
                SUM(TotalQueryTimeMs)/SUM(NumQueries) AS MsObjectModel
            FROM Search_PerMinuteTotalOMQueryLatency
            WHERE
                (((SELECT COUNT(*) FROM @applicationTypes) = 0) OR
                    (ApplicationType IN 
                        (SELECT OMInner.ApplicationType FROM Search_PerMinuteTotalOMQueryLatency OMInner INNER JOIN @applicationTypes AppType ON OMInner.ApplicationType = AppType.ApplicationType)))
                AND
                (((SELECT COUNT(*) FROM @resultPageUrls) = 0) OR
                    (ResultPageUrl IN 
                        (SELECT OMInner.ResultPageUrl FROM Search_PerMinuteTotalOMQueryLatency OMInner INNER JOIN @resultPageUrls ResUrl ON OMInner.ResultPageUrl = ResUrl.ResultPageUrl)))
                AND
                (((SELECT COUNT(*) FROM @imsFlows) = 0) OR
                    (ImsFlow IN 
                        (SELECT OMInner.ImsFlow FROM Search_PerMinuteTotalOMQueryLatency OMInner INNER JOIN @imsFlows Ims ON OMInner.ImsFlow = Ims.ImsFlow)))
                AND
                (((SELECT COUNT(*) FROM @tenantIds) = 0) OR
                    (TenantId IN 
                        (SELECT OMInner.TenantId FROM Search_PerMinuteTotalOMQueryLatency OMInner INNER JOIN @tenantIds Tenant ON OMInner.TenantId = Tenant.TenantId)))
                AND
                (@applicationId = ''00000000-0000-0000-0000-000000000000'' OR ApplicationId = @applicationId) 
                AND
                LogTime <= @endDate 
                AND
                LogTime >= @startDate
            GROUP BY LogTime
            ORDER BY LogTime
        END
    ' 
END
GO
