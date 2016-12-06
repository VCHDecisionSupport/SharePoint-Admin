USE [DSSPPROD_UsageAndHealth]
GO
/****** Object:  UserDefinedFunction [dbo].[fn_AlterTableHelper]    Script Date: 11/10/2016 4:16:42 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[fn_AlterTableHelper]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'CREATE FUNCTION [dbo].[fn_AlterTableHelper]
(
    @TableName sysname,
    @ColumnList nvarchar(3800)
)
RETURNS nvarchar(MAX)
AS
BEGIN
    DECLARE @Ret nvarchar(MAX)
    DECLARE @Pos int,
        @CommaPos int,
        @Start int,
        @ColText nvarchar(255)
    DECLARE @Columns TABLE 
        (ColumnName sysname,
         ColumnText nvarchar(255))
    SET @Start = 0
    SELECT @Pos = CHARINDEX('' '', @ColumnList)
    SELECT @CommaPos = CHARINDEX('','', @ColumnList)
    IF (@CommaPos = 0)
        SELECT @CommaPos = LEN(@ColumnList)
    WHILE (@Pos > 0)
    BEGIN
        INSERT INTO @Columns (ColumnName, ColumnText)
        SELECT
            LTRIM(SUBSTRING(@ColumnList, @Start, @Pos-@Start)), -- ColumnName
            LTRIM(SUBSTRING(@ColumnList, @Start, @CommaPos-@Start)) -- ColumnText
        SELECT @Start = @CommaPos + 1            
        SELECT @CommaPos = CHARINDEX('','', @ColumnList, @CommaPos+1)
        IF (@CommaPos > 0)
        BEGIN            
            SELECT @Pos = CHARINDEX('' '', @ColumnList, @Start+1)            
        END
        ELSE
        BEGIN            
            BREAK
        END
    END
    SELECT @ColText = min(c.ColumnText + '','')
    FROM @Columns as c
    WHERE NOT EXISTS (
        SELECT name from sys.columns as s
        WHERE c.ColumnName COLLATE DATABASE_DEFAULT = s.name COLLATE DATABASE_DEFAULT
        AND s.object_id = object_id(''[dbo].['' + @TableName + '']'')
    )
    WHILE (@ColText is not null)
    BEGIN
        IF (@Ret is null)
        BEGIN    
            SELECT @Ret = ''ALTER TABLE '' + ''[dbo].['' + @TableName + '']'' + '' ADD ''
        END
        SELECT @Ret = @Ret + @ColText
        SELECT @ColText = min(c.ColumnText + '','')
            FROM @Columns as c
   	    WHERE NOT EXISTS (
              SELECT name from sys.columns as s
              WHERE c.ColumnName COLLATE DATABASE_DEFAULT = s.name COLLATE DATABASE_DEFAULT
              AND s.object_id = object_id(''[dbo].['' + @TableName + '']'')
            )
            AND c.ColumnText > @ColText
    END
    RETURN SUBSTRING(@Ret, 1, LEN(@Ret)-1)
END
' 
END

GO
