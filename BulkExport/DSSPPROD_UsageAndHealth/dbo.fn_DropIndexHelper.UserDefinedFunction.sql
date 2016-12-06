USE [DSSPPROD_UsageAndHealth]
GO
/****** Object:  UserDefinedFunction [dbo].[fn_DropIndexHelper]    Script Date: 11/10/2016 4:16:42 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[fn_DropIndexHelper]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'CREATE FUNCTION [dbo].[fn_DropIndexHelper]
(
    @TableName sysname,
    @IndexName sysname
)
RETURNS nvarchar(MAX)
AS
BEGIN
    RETURN ''DROP INDEX '' + ''[dbo].['' + @TableName + '']'' + ''.'' + @IndexName 
END
' 
END

GO
