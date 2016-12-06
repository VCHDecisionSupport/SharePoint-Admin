USE [DSSPPROD_UsageAndHealth]
GO
/****** Object:  StoredProcedure [dbo].[proc_GetDiagnosticsData]    Script Date: 11/10/2016 4:16:42 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[proc_GetDiagnosticsData]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[proc_GetDiagnosticsData] (@CorrelationId uniqueidentifier , @ScopeId bigint  = NULL , @Name nvarchar (256)  = NULL ) 
                         AS
                         BEGIN
                             SET NOCOUNT ON;
                             SELECT TOP(1000000) CorrelationId,ScopeId,Name, ValueInt,  ValueFloat, Valuestring,ValueBinary, LogTime, RowCreatedTime  
                             From MonitoredScopeDiagnosticsData  WITH(NOLOCK)
                             WHERE
                                CorrelationId=@CorrelationId AND 
                                (@ScopeId is NULL OR ScopeId=@ScopeId) AND
                                (@Name is NULL OR Name LIKE @Name)
                             ORDER BY LogTime
                         END' 
END
GO
