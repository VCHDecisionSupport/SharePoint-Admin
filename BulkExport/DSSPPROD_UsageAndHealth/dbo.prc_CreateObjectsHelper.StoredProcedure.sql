USE [DSSPPROD_UsageAndHealth]
GO
/****** Object:  StoredProcedure [dbo].[prc_CreateObjectsHelper]    Script Date: 11/10/2016 4:16:41 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[prc_CreateObjectsHelper]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[prc_CreateObjectsHelper]
(
    @TypeName nvarchar(100),
    @Columns nvarchar(3800),
    @RetentionPeriod tinyint = 31, 
    @MaxTotalBytes bigint = NULL, -- 440 MB per partition by default
    @Debug bit = 0 -- If true, spews generated SQL
)
AS
BEGIN
    SET NOCOUNT ON
    DECLARE @SQL nvarchar(4000), 
            @Counter tinyint,
            @TableName sysname,
            @MaxPartitions tinyint,
            @ConfigName nvarchar(255)	    
   BEGIN TRY
	BEGIN TRAN
   	-- Grab an exclusive lock on configuration, or block waiting for it.
	SELECT TOP 1 1 from Configuration WITH (TABLOCKX) WHERE 1=0
        SELECT TOP 1 1 from sysobjects WITH (TABLOCKX) WHERE 1=0
        SELECT TOP 1 1 from syscolumns WITH (TABLOCKX) WHERE 1=0
        SELECT TOP 1 1 from sysindexes WITH (TABLOCKX) WHERE 1=0
        -- Ensure retention span is within boundaries
        IF ((@RetentionPeriod IS NULL) OR (@RetentionPeriod < 0) OR (@RetentionPeriod > 31))
            SELECT @RetentionPeriod = 31
        -- Call ALTER if the view already exists
        IF (select name from sys.objects where object_id = object_id(''[dbo].['' + @TypeName + '']'') and type = ''V'') IS NOT NULL 
        BEGIN
            exec dbo.proc_AlterRetentionForType @TypeName, @RetentionPeriod, @Debug
            exec dbo.prc_AlterObjectsHelper @TypeName, @Columns, @Debug
            exec dbo.prc_EnsureIndexHelper @TypeName, ''IX_MachineName'', ''MachineName, LogTime desc'', 0, @Debug
            exec dbo.prc_EnsureIndexHelper @TypeName, ''IX_LogTime'', ''LogTime'', 0, @Debug
            IF (@@TRANCOUNT > 0)
                COMMIT TRAN
            RETURN
        END
        SELECT @Columns = LTRIM(RTRIM(@Columns))
        IF (RIGHT(@Columns, 2) <> '' ,'')
        BEGIN
            WHILE (RIGHT(@Columns,1) = '','')
                SELECT @Columns = LEFT(@Columns, LEN(@Columns)-1)
		IF (LEN(ISNULL(@Columns,'''')) > 0)
	            SELECT @Columns = @Columns + '' ,''
        END
        SET @MaxPartitions = 31 + 1
        SET @Counter = 0
        WHILE (@Counter < @MaxPartitions)
        BEGIN
            SET @TableName = @TypeName + ''_Partition'' + cast(@Counter as nvarchar)
            PRINT ''Creating '' + ''[dbo].['' + @TableName + '']''
            SELECT @SQL = dbo.fn_CreateTableHelper(@TableName, @Counter, @Columns)
            IF (@Debug = 1)
                PRINT @SQL
            ELSE
			BEGIN
				exec sp_executesql @SQL			
			END
            PRINT ''Creating index IX_MachineName on '' + ''[dbo].['' + @TableName + '']''
            SELECT @SQL = dbo.fn_EnsureIndexHelper(@TableName, ''IX_MachineName'', ''MachineName, LogTime desc'', 0)
            IF (@Debug = 1)
                PRINT @SQL
            ELSE
                exec sp_executesql @SQL
            PRINT ''Creating index IX_LogTime on '' + ''[dbo].['' + @TableName + '']''
            SELECT @SQL = dbo.fn_EnsureIndexHelper(@TableName, ''IX_LogTime'', ''LogTime'', 0)
            IF (@Debug = 1)
                PRINT @SQL
            ELSE
                exec sp_executesql @SQL
            SELECT @Counter = @Counter +1
        END
        --CREATE VIEW
        IF OBJECT_ID(''[dbo].['' + @TypeName + '']'') IS NULL
            BEGIN
            SET @SQL = '' CREATE VIEW '' + ''[dbo].['' + @TypeName + '']'' + '' AS ''
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
        END
        --Create TVF functions
        exec dbo.prc_CreateTVFHelper @TypeName,''LogTime'',''@BeginTime DateTime,@EndTime DateTime'',''IX_LogTime'',
            ''LogTime Between @BeginTime and @EndTime'', @Debug
        -- Both of these will ALTER rather than drop and recreate
        exec dbo.prc_CreateEnumProcHelper @TypeName, @Debug
        exec dbo.prc_CreateInsertProcHelper @TypeName, @Columns, @Debug
	        -- Set the current partition ID
        SELECT @ConfigName = ''Max Partition ID - '' + @TypeName
        exec prc_SetConfigValue @ConfigName, 0
		-- The max number of days to store data
        SELECT @ConfigName = ''Retention Period - '' + @TypeName
        exec prc_SetConfigValue @ConfigName, @RetentionPeriod
		-- The max number of bytes to store
		IF (@MaxTotalBytes is null)
		SELECT @MaxTotalBytes = dbo.fn_GetDefaultMaxBytesPerPartition()
		IF (@MaxTotalBytes < 0)
			SET @MaxTotalBytes = 0 -- Don''t log anything.
        --If you change the string Max Total bytes, needs
        --to update in sts\powershell\cmdlet\SPDiagnosticsProvider.cs 
        SELECT @ConfigName = ''Max Total Bytes - '' + @TypeName
		exec prc_SetConfigValue @ConfigName, @MaxTotalBytes
        COMMIT TRAN
    END TRY
    BEGIN CATCH
        IF (@@Trancount > 0)
            ROLLBACK TRAN
		-- Ignore duplicate errors
		IF (SUBSTRING(ERROR_MESSAGE(),1, LEN(''There is already an object named'')) <> ''There is already an object named'') 
		BEGIN
			SELECT @SQL = ''Errors occurred '' + ERROR_MESSAGE()
		        RAISERROR(@SQL, 10, 1)
		END
    END CATCH
END
' 
END
GO
