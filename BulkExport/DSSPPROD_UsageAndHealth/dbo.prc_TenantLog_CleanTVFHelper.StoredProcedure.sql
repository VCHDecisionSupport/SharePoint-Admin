USE [DSSPPROD_UsageAndHealth]
GO
/****** Object:  StoredProcedure [dbo].[prc_TenantLog_CleanTVFHelper]    Script Date: 11/10/2016 4:16:42 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[prc_TenantLog_CleanTVFHelper]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[prc_TenantLog_CleanTVFHelper]
(
    @QueryName nvarchar(4000),
    @Debug bit = 0
)
AS
BEGIN
   DECLARE @SQL nvarchar(max),
           @FuncName nvarchar(255)
        SET @FuncName=''[dbo].[TVF_TenantLog_''+@QueryName+'']''
        SET @SQL = ''IF object_id('''''' + @FuncName+ '''''') is not null drop function '' + @FuncName
        IF (@Debug = 1)
            PRINT @SQL
        ELSE
            exec sp_executesql @SQL
END
' 
END
GO
