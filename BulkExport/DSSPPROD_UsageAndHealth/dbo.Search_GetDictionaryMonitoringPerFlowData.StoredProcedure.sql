USE [DSSPPROD_UsageAndHealth]
GO
/****** Object:  StoredProcedure [dbo].[Search_GetDictionaryMonitoringPerFlowData]    Script Date: 11/10/2016 4:16:42 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Search_GetDictionaryMonitoringPerFlowData]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
                    CREATE PROCEDURE [dbo].[Search_GetDictionaryMonitoringPerFlowData]
                         @applicationId uniqueIdentifier,
                         @flowName nvarchar(128),
                         @startDate datetime,
                         @endDate datetime
                    AS
                    BEGIN
                        SELECT *
                        FROM Search_DictionaryManagementMonitoring WHERE
                            ApplicationId = @applicationId AND 
                            FlowName = @flowName AND
                            LogTime >= @startDate AND
                            LogTime <= @endDate 
                        ORDER BY LogTime ASC
                    END
                ' 
END
GO
