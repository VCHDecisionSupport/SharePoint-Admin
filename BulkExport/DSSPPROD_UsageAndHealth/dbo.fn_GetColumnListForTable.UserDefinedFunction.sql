USE [DSSPPROD_UsageAndHealth]
GO
/****** Object:  UserDefinedFunction [dbo].[fn_GetColumnListForTable]    Script Date: 11/10/2016 4:16:42 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[fn_GetColumnListForTable]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'CREATE FUNCTION [dbo].[fn_GetColumnListForTable]
(
    @TableName sysname
)
RETURNS nvarchar(4000)
AS
BEGIN
    DECLARE @Columns TABLE (Pos int IDENTITY(1,1), ColumnDesc nvarchar(3800))
    DECLARE @Ret nvarchar(4000),
            @Pos int
    INSERT INTO @Columns (ColumnDesc)
    SELECT c.name + '' '' + s.name + 
        CASE WHEN s.name in (''varbinary'', ''varchar'', 
        ''binary'', ''char'') THEN            
            ''('' + CASE WHEN c.max_length < 0 THEN ''MAX'' else CAST(c.max_length as nvarchar) END + '')''         
        WHEN s.name in (''nvarchar'', ''nchar'')
            THEN ''('' + CASE WHEN c.max_length < 0 THEN ''MAX'' else CAST(c.max_length/2 as nvarchar) END + '')''         
        ELSE '''' 
        END
    FROM sys.columns as c 
    INNER JOIN sys.types as s 
    ON s.user_type_id = c.user_type_id
    WHERE c.object_id = object_id(''[dbo].['' + @TableName + '']'')
    and c.name not in (''PartitionId'', ''RowId'', ''MachineName'', ''RowCreatedTime'', ''LogTime'')
    order by column_id 
    SELECT @Pos = min(Pos) FROM @Columns
    WHILE (@Pos is not null)
    BEGIN
        IF (@Ret is not null)
            SELECT @Ret = @Ret + '',''
        SELECT @Ret = ISNULL(@Ret,'''') + ColumnDesc + '' '' FROM @Columns WHERE Pos = @Pos
        SELECT @Pos = min(Pos) FROM @Columns WHERE Pos > @Pos
    END    
    RETURN @Ret
END
' 
END

GO
