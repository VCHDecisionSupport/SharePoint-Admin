USE [DSSPPROD_UsageAndHealth]
GO
/****** Object:  StoredProcedure [dbo].[Search_GetDictionaryMonitoringLastRunData]    Script Date: 11/10/2016 4:16:42 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Search_GetDictionaryMonitoringLastRunData]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
                    CREATE PROCEDURE [dbo].[Search_GetDictionaryMonitoringLastRunData]
                         @applicationId uniqueIdentifier,
                         @dictionaryType nvarchar(128),
                         @deploymentStatus int

                    AS
                    BEGIN
                        SELECT TOP(1) *
                        FROM Search_DictionaryManagementMonitoring WHERE
                            ApplicationId = @applicationId AND 
                            FlowName = @dictionaryType AND
                            Status = @deploymentStatus
                        ORDER BY LogTime DESC 
                    END
                ' 
END
GO
