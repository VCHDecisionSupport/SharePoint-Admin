USE [DSSPPROD_UsageAndHealth]
GO
/****** Object:  UserDefinedFunction [dbo].[fn_EnsureIndexHelper]    Script Date: 11/10/2016 4:16:42 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[fn_EnsureIndexHelper]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'CREATE FUNCTION [dbo].[fn_EnsureIndexHelper]
(
    @TableName sysname,
    @IndexName sysname,
    @ColumnList nvarchar(3800),
    @Clustered bit = 0
)
RETURNS nvarchar(MAX)
AS
BEGIN
    IF (@Clustered = 1)
    BEGIN
        RETURN ''IF NOT EXISTS (select name from sys.indexes where name = '''''' + @IndexName + '''''' and object_id = object_id(''''[dbo].['' + @TableName + '']'''')) CREATE CLUSTERED INDEX '' + @IndexName + '' ON '' + ''[dbo].['' + @TableName + '']'' + ''('' + @ColumnList + '')''
    END
    RETURN ''IF NOT EXISTS (select name from sys.indexes where name = '''''' + @IndexName + '''''' and object_id = object_id(''''[dbo].['' + @TableName + '']'''')) CREATE NONCLUSTERED INDEX '' + @IndexName + '' ON '' + ''[dbo].['' + @TableName + '']'' + ''('' + @ColumnList + '')''
END
' 
END

GO
