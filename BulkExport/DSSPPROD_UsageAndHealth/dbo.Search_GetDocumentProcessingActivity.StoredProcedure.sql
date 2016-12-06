USE [DSSPPROD_UsageAndHealth]
GO
/****** Object:  StoredProcedure [dbo].[Search_GetDocumentProcessingActivity]    Script Date: 11/10/2016 4:16:42 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Search_GetDocumentProcessingActivity]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[Search_GetDocumentProcessingActivity]
        @contentSources xml,
        @applicationId uniqueIdentifier,
        @startDate datetime,
        @endDate datetime,
        @machineName nvarchar(128),
        @nodeName nvarchar(256),
        @flowName nvarchar(256),
        @subFlowNames xml
    AS
    BEGIN
        WITH ContentSources(Id, AppNameGuid) AS
        (
            SELECT nref.value(''@id'', ''int'') Id,
                   nref.value(''@appnameguid'', ''uniqueidentifier'') AppNameGuid
            FROM   @contentSources.nodes(''//ContentSources/ContentSource'') AS R(nref)
        ),
	
	SelectedSubFlows(SubFlowName) AS 
        (
            SELECT nref.value(''@subflowname'', ''nvarchar(100)'') SubFlowName
            FROM @subFlowNames.nodes(''//SelectedSubFlows/SelectedSubFlow'') AS S(nref)
        )

        SELECT 
			SubFlow AS FullSubFlowName,
            /* (ParentFlow + '':'' + SubFlow) AS FullSubFlowName, */
            LogTime,
            (SUM(SubFlowTimeMs) / SUM(NoOfExecutions)) AS SubFlowTimeAvgInMs
        FROM Search_PerMinuteSubFlowTimings
             INNER JOIN ContentSources ON Search_PerMinuteSubFlowTimings.ContentSourceId = ContentSources.Id AND Search_PerMinuteSubFlowTimings.ApplicationId = ContentSources.AppNameGuid
        WHERE (@applicationId = ''00000000-0000-0000-0000-000000000000'' OR ApplicationId = @applicationId) AND
            LogTime <= @endDate AND
            LogTime >= @startDate AND
            (@machineName = ''00000000-0000-0000-0000-000000000000'' OR MachineName = @machineName) AND
            (@nodeName = ''00000000-0000-0000-0000-000000000000'' OR NodeName = @nodeName) AND
            (@flowName = ''00000000-0000-0000-0000-000000000000'' OR ParentFlow = @flowName) AND
            SubFlow IN (SELECT SubFlowName FROM SelectedSubFlows) AND
            FlowCategory = ''ContentProcessing'' /* Only get CTS timing data */
        GROUP BY SubFlow, LogTime
        ORDER BY SubFlow, LogTime
    END
' 
END
GO
