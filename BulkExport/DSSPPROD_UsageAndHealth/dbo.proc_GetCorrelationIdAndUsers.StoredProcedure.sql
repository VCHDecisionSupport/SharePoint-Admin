USE [DSSPPROD_UsageAndHealth]
GO
/****** Object:  StoredProcedure [dbo].[proc_GetCorrelationIdAndUsers]    Script Date: 11/10/2016 4:16:42 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[proc_GetCorrelationIdAndUsers]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[proc_GetCorrelationIdAndUsers] (@StartTime datetime2 ) 
                            AS
                            BEGIN
                               SET NOCOUNT ON;
                               SELECT CorrelationId,Name,ValueString FROM MonitoredScopeDiagnosticsData  WITH(NOLOCK)
                               WHERE
                                    CorrelationId in (SELECT DISTINCT(CorrelationId) From MonitoredScopeDiagnosticsData  WITH(NOLOCK) WHERE RowCreatedTime>@StartTime)
                                    AND Name=''CurrentUser''
                               ORDER BY LogTime
                            END' 
END
GO
