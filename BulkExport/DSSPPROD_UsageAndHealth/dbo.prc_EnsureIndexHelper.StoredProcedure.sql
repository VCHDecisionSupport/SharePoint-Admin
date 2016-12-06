USE [DSSPPROD_UsageAndHealth]
GO
/****** Object:  StoredProcedure [dbo].[prc_EnsureIndexHelper]    Script Date: 11/10/2016 4:16:41 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[prc_EnsureIndexHelper]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[prc_EnsureIndexHelper]
(
    @TypeName nvarchar(100),
    @IndexName sysname,
    @Columns nvarchar(3800),
    @Drop bit = 0,
    @Debug bit = 0,
    @Clustered bit = 0
)
AS
BEGIN
    SET NOCOUNT ON
    DECLARE @SQL nvarchar(4000), 
            @Counter tinyint,
            @TableName sysname,
            @MaxPartitions tinyint,
            @TotalColumns nvarchar(3800),
            @Ret bit
    SET @MaxPartitions = 31 + 1
    -- Make sure @Columns does not end with a comma
    SELECT @Columns = LTRIM(RTRIM(@Columns))
    IF (RIGHT(@Columns, 1) = '','')
    BEGIN
        WHILE (RIGHT(@Columns,1) = '','')
            SELECT @Columns = LEFT(@Columns, LEN(@Columns)-1)
    END
    BEGIN TRY
        BEGIN TRAN
        SET @Counter = 0
        WHILE (@Counter < @MaxPartitions)
        BEGIN
            SET @TableName = @TypeName + ''_Partition'' + cast(@Counter as nvarchar)
            IF (@Drop = 0)
            BEGIN 
                exec @Ret = dbo.prc_IndexMatches @TableName, @IndexName, @Columns
                IF (@Ret = 0)
                BEGIN
                    IF (select 1 from sys.indexes where object_id = object_id(''[dbo].['' + @TableName + '']'') and name = @IndexName) IS NOT NULL            
                    BEGIN
                        SELECT ''Dropping index '' + @IndexName  +'' from '' + ''[dbo].['' + @TableName + '']''
                        SELECT @SQL = dbo.fn_DropIndexHelper(@TableName, @IndexName)
                        IF (@Debug = 1)
                            PRINT @SQL
                        ELSE IF (@SQL is not null) -- If null, all columns are already present
                            exec sp_executesql @SQL
                    END
                    SELECT ''Creating index '' + @IndexName  +'' on '' + ''[dbo].['' + @TableName + '']''
                    SELECT @SQL = dbo.fn_EnsureIndexHelper(@TableName, @IndexName, @Columns,@Clustered)
                END
            END
            ELSE
            BEGIN
                IF (select 1 from sys.indexes where object_id = object_id(''[dbo].['' + @TableName + '']'') and name = @IndexName) IS NOT NULL            
                BEGIN
                    SELECT ''Dropping index '' + @IndexName  +'' from '' + ''[dbo].['' + @TableName + '']''
                    SELECT @SQL = dbo.fn_DropIndexHelper(@TableName, @IndexName)
                END
            END
            IF (@Debug = 1)
                PRINT @SQL
            ELSE IF (@SQL is not null) -- If null, all columns are already present
                exec sp_executesql @SQL
            SELECT @Counter = @Counter +1
        END
        COMMIT TRAN
    END TRY
    BEGIN CATCH
        IF (@@Trancount > 0)
            ROLLBACK TRAN
        SELECT @SQL = ''Errors occurred '' + ERROR_MESSAGE()
        RAISERROR(@SQL, 10, 1)
    END CATCH
END
' 
END
GO
