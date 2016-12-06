USE [DSSPPROD_UsageAndHealth]
GO
/****** Object:  StoredProcedure [dbo].[prc_CleanObjectsHelper]    Script Date: 11/10/2016 4:16:41 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[prc_CleanObjectsHelper]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[prc_CleanObjectsHelper]
(
    @TypeName nvarchar(100),
    @Debug bit = 0
)
AS
BEGIN
    DECLARE @SQL nvarchar(4000),
            @Counter tinyint,
            @TableName nvarchar(255),
            @MaxPartitions tinyint
    SET @MaxPartitions = 31 + 1
    BEGIN TRY
        BEGIN TRAN
        SET @Counter = 0
        WHILE (@Counter < @MaxPartitions)
        BEGIN
            SET @TableName = @TypeName + ''_Partition'' + cast(@Counter as nvarchar)
            PRINT ''Dropping '' + @TableName
            SELECT @SQL = dbo.fn_DropTableHelper(@TableName)
            IF (@Debug = 1)
                PRINT @SQL
            ELSE
                exec sp_executesql @SQL
            SELECT @Counter = @Counter +1
        END
        SET @SQL = ''IF object_id('''''' + ''[dbo].['' + @TypeName + '']'' + '''''') is not null drop view '' + ''[dbo].['' + @TypeName + '']''
        IF (@Debug = 1)
            PRINT @SQL
        ELSE
            exec sp_executesql @SQL
        SET @SQL = ''IF object_id('''''' + ''[dbo].[prc_Enum'' + @TypeName + '']'' + '''''') is not null drop procedure '' + ''[dbo].[prc_Enum'' + @TypeName + '']''
        IF (@Debug = 1)
            PRINT @SQL
        ELSE
            exec sp_executesql @SQL
        SET @SQL = ''IF object_id('''''' + ''[dbo].[prc_Insert'' + @TypeName + '']'' + '''''') is not null drop procedure '' + ''[dbo].[prc_Insert'' + @TypeName + '']''
        IF (@Debug = 1)
            PRINT @SQL
        ELSE
            exec sp_executesql @SQL
        exec dbo.prc_CleanTVFHelper @TypeName,''LogTime'',@Debug
	SET @SQL = ''DELETE FROM Configuration WHERE ConfigName LIKE ''''%- '' + @TypeName + ''''''''
        IF (@Debug = 1)
            PRINT @SQL
        ELSE
            exec sp_executesql @SQL
        COMMIT TRAN
    END TRY
    BEGIN CATCH
        IF (@@Trancount > 0)
            ROLLBACK TRAN        
        SELECT @SQL = ''Errors occurred '' + ERROR_MESSAGE()
-- LEVN: not sure what the right severity is...
        RAISERROR(@SQL, 10, 1)
    END CATCH
END
' 
END
GO
