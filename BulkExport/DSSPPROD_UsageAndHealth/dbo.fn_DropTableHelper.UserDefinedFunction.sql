USE [DSSPPROD_UsageAndHealth]
GO
/****** Object:  UserDefinedFunction [dbo].[fn_DropTableHelper]    Script Date: 11/10/2016 4:16:42 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[fn_DropTableHelper]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'CREATE FUNCTION [dbo].[fn_DropTableHelper] 
(
    @TableName sysname
)
RETURNS nvarchar(4000)
AS
BEGIN
    RETURN ''IF object_id('''''' + ''[dbo].['' + @TableName + '']'' + '''''') is not null DROP TABLE '' + ''[dbo].['' + @TableName + '']''
END
' 
END

GO
