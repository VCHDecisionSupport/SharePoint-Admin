USE [DSSPPROD_UsageAndHealth]
GO
/****** Object:  StoredProcedure [dbo].[proc_GetMonitoredScopes]    Script Date: 11/10/2016 4:16:42 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[proc_GetMonitoredScopes]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[proc_GetMonitoredScopes] (@CorrelationId uniqueidentifier ) 
                            AS
                            BEGIN
                                SET NOCOUNT ON;
                                 SELECT TOP(1000000) CorrelationId, Name, ScopeId, ParentId,StartTime, EndTime, RowCreatedTime, MachineName FROM MonitoredScopes WITH(NOLOCK)
                                 WHERE CorrelationId=@CorrelationId ORDER BY StartTime
                            END' 
END
GO
