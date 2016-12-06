USE [DSSPPROD_UsageAndHealth]
GO
/****** Object:  StoredProcedure [dbo].[Search_GetIndexEngineQueryLatencyVerbose]    Script Date: 11/10/2016 4:16:42 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Search_GetIndexEngineQueryLatencyVerbose]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
    CREATE PROCEDURE [dbo].[Search_GetIndexEngineQueryLatencyVerbose]
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
                COUNT(E.LookupMs) AS NumQueries,
                AVG(E.LookupMs) + AVG(E.DocSumMs)
                    AS MsFsQueryLatency,
                AVG(L.TotalQueryTimeMs)
                    AS MsMarsQueryLatency
            FROM Search_VerboseIndexEngineQueryLatency E
            INNER JOIN Search_VerboseQueryTags Tags on Tags.CorrelationId = E.CorrelationId
            RIGHT JOIN Search_VerboseIndexLookupQueryLatency L on E.CorrelationId = L.CorrelationId
            WHERE (@applicationId = ''00000000-0000-0000-0000-000000000000'' OR E.ApplicationId = @applicationId) AND
                   (((SELECT COUNT(*) FROM @machineNames) = 0) OR 
                      (E.MachineName IN (SELECT MachineName FROM @machineNames))) AND
                   (((SELECT COUNT(*) FROM @applicationTypes) = 0) OR
                     Tags.ApplicationType IN (SELECT ApplicationType from @applicationTypes)) AND
                   (((SELECT COUNT(*) FROM @imsFlows) = 0) OR
                     Tags.ImsFlow IN (SELECT ImsFlow from @imsFlows)) AND
                   (((SELECT COUNT(*) FROM @resultPageUrls) = 0) OR
                     Tags.ResultPageUrl IN (SELECT ResultPageUrl from @resultPageUrls)) AND
                   (((SELECT COUNT(*) FROM @tenantIds) = 0) OR
                     Tags.TenantId IN (SELECT TenantId from @tenantIds)) AND
                   E.LogTime <= @endDate AND
                   E.LogTime >= @startDate
            GROUP BY E.MachineName, E.LogTime, L.LogTime
            ORDER BY L.LogTime
        END
    ' 
END
GO
