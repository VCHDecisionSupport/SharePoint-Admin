USE [DSSPPROD_UsageAndHealth]
GO
/****** Object:  StoredProcedure [dbo].[Search_GetQueryLatencyVerbose]    Script Date: 11/10/2016 4:16:42 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Search_GetQueryLatencyVerbose]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
    CREATE PROCEDURE [dbo].[Search_GetQueryLatencyVerbose]
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
                OM.LogTime as LogTime, 
                COUNT(OM.QPTimeMs) AS NumQueries,
                AVG(OM.QPTimeMs)
                    AS MsBackend,
                AVG(OM.TotalQueryTimeMs)
                    AS MsObjectModel
            FROM dbo.Search_VerboseOMQueryLatency OM
            INNER JOIN Search_VerboseQueryTags Tags on Tags.CorrelationId = OM.CorrelationId
            WHERE (@applicationId = ''00000000-0000-0000-0000-000000000000'' OR OM.ApplicationId = @applicationId) AND
                   (((SELECT COUNT(*) FROM @applicationTypes) = 0) OR
                     Tags.ApplicationType IN (SELECT ApplicationType from @applicationTypes)) AND
                   (((SELECT COUNT(*) FROM @imsFlows) = 0) OR
                     Tags.ImsFlow IN (SELECT ImsFlow from @imsFlows)) AND
                   (((SELECT COUNT(*) FROM @resultPageUrls) = 0) OR
                     Tags.ResultPageUrl IN (SELECT ResultPageUrl from @resultPageUrls)) AND
                   (((SELECT COUNT(*) FROM @tenantIds) = 0) OR
                     Tags.TenantId IN (SELECT TenantId from @tenantIds)) AND
                   OM.LogTime <= @endDate AND
                   OM.LogTime >= @startDate
            GROUP BY OM.LogTime
            ORDER BY OM.LogTime
        END
    ' 
END
GO
