USE [DSSPPROD_UsageAndHealth]
GO
/****** Object:  StoredProcedure [dbo].[prc_AlterObjectsHelper]    Script Date: 11/10/2016 4:16:41 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[prc_AlterObjectsHelper]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[prc_AlterObjectsHelper]
(
    @TypeName nvarchar(100),
    @Columns nvarchar(3800), -- The new columns to add
    @Debug bit = 0 -- If true, spews generated SQL
)
AS
BEGIN
    SET NOCOUNT ON
    DECLARE @SQL nvarchar(4000), 
            @Counter tinyint,
            @TableName sysname,
            @MaxPartitions tinyint,
            @TotalColumns nvarchar(3800),
            @PKColumns nvarchar(1200),
            @PKName sysname,
            @Match bit ,
	    @Changes bit
    SET @Changes = 0 
    SELECT @Columns = LTRIM(RTRIM(@Columns))
    IF (RIGHT(@Columns, 2) <> '' ,'')
    BEGIN
        WHILE (RIGHT(@Columns,1) = '','')
            SELECT @Columns = LEFT(@Columns, LEN(@Columns)-1)
		IF (LEN(ISNULL(@Columns,'''')) > 0)
            SELECT @Columns = @Columns + '' ,''
    END
    BEGIN TRY
        SET @MaxPartitions = 31 + 1
        SET @Counter = 0
        WHILE (@Counter < @MaxPartitions)
        BEGIN
            SET @TableName = @TypeName + ''_Partition'' + cast(@Counter as nvarchar)
            PRINT ''Updating '' + ''[dbo].['' + @TableName + '']''
            SELECT @SQL = dbo.fn_AlterTableHelper(@TableName, @Columns)
            IF (@SQL is not null) -- If null, all columns are already present
	             BEGIN
		            SET @Changes = 1
		            IF (@Debug = 1)
		                 PRINT @SQL
		            ELSE
    		            exec sp_executesql @SQL
	             END
 	       ELSE IF (@Changes = 0)
	          BEGIN
	                PRINT ''No changes.  Exiting.''
		            RETURN;
	          END
            SELECT @Counter = @Counter +1
        END
        exec dbo.prc_EnsureIndexHelper @TypeName, ''IX_MachineName'', ''MachineName, LogTime desc'', 0, @Debug
        exec dbo.prc_EnsureIndexHelper @TypeName, ''IX_LogTime'', ''LogTime'', 0, @Debug
        SET @SQL = ''ALTER VIEW '' + ''[dbo].['' + @TypeName + '']'' + '' AS ''
        SET @Counter = 0
        WHILE (@Counter < @MaxPartitions)
        BEGIN
            IF (@Counter > 0)
                SET @SQL = @SQL + '' with (NOLOCK) UNION ALL ''
            SELECT @SQL = @SQL + '' SELECT * FROM '' + ''[dbo].['' + @TypeName + ''_Partition'' + cast(@Counter as nvarchar) + '']''
            SET @Counter = @Counter+1
        END
        IF (@Debug = 1)
            PRINT @SQL
        ELSE
            exec sp_executesql @SQL
        -- Grab the latest list of columns
        SELECT @TotalColumns = dbo.fn_GetColumnListForTable(@TableName)
        exec dbo.prc_CreateInsertProcHelper @TypeName, @TotalColumns, @Debug
        exec dbo.prc_CreateEnumProcHelper @TypeName, @Debug
    END TRY
    BEGIN CATCH
        SELECT @SQL = ''Errors occurred '' + ERROR_MESSAGE()
        RAISERROR(@SQL, 10, 1)
    END CATCH
END
' 
END
GO
