USE [DSSPPROD_UsageAndHealth]
GO
/****** Object:  StoredProcedure [dbo].[prc_IndexMatches]    Script Date: 11/10/2016 4:16:42 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[prc_IndexMatches]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[prc_IndexMatches]
(
    @TableName sysname,
    @IndexName sysname,
    @Columns nvarchar(3800)
)
AS
BEGIN
    DECLARE @Ret bit
    SET @Ret = 0
    IF (select 1 from sys.indexes where object_id = object_id(''[dbo].['' + @TableName + '']'') and name = @IndexName) IS NOT NULL
    BEGIN
        DECLARE @Indexes TABLE (index_name sysname, index_description sysname, index_keys nvarchar(2126))
        INSERT INTO @Indexes (index_name, index_description, index_keys) EXEC sp_helpindex @TableName
        IF (LTRIM(RTRIM(REPLACE(REPLACE (REPLACE(@Columns, '' desc'', ''(-)''), ''asc'', ''''),'' '', '''')))
		= 
    	(select REPLACE(LTRIM(RTRIM(index_keys)),'' '','''') FROM @Indexes WHERE index_name = @IndexName))
        BEGIN
            SET @Ret = 1
        END
    END
    RETURN @Ret
END
' 
END
GO
