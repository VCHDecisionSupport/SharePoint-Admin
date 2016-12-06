USE [DSSPPROD_UsageAndHealth]
GO
/****** Object:  StoredProcedure [dbo].[proc_UpdateStatistics]    Script Date: 11/10/2016 4:16:42 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[proc_UpdateStatistics]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[proc_UpdateStatistics]
AS
    SET NOCOUNT ON
    DECLARE @objectid int
    DECLARE @indexid int
    DECLARE @command varchar(8000)
    DECLARE @baseCommand varchar(8000)
    DECLARE @schemaname sysname
    DECLARE @objectname sysname
    DECLARE @statname sysname
    DECLARE @indexname sysname
    DECLARE @currentDdbId int
    DECLARE @bNeedFullScan bit 
    SELECT @currentDdbId = DB_ID()
    SELECT @bNeedFullScan = 0
    PRINT CONVERT(nvarchar, GETDATE(), 126) + '': Starting''
    PRINT CONVERT(nvarchar, GETDATE(), 126) + '': Dropping automatically created stats on user tables''
    -- Get all auto-created stats (for non-system tables ''S'')
    DECLARE statsToDrop CURSOR FORWARD_ONLY READ_ONLY FOR 
    SELECT
        quotename(o.name),
        quotename(s.name)
    FROM 
        sys.stats AS s
    INNER JOIN 
        sys.objects AS o
    ON 
        o.object_id = s.object_id
    WHERE 
        (s.auto_created = 1) AND
        o.type <> ''S'' 
    -- Loop through the stats we want to drop.
    OPEN statsToDrop
    FETCH NEXT
    FROM
        statsToDrop
    INTO 
        @objectname, 
        @statname
    WHILE @@FETCH_STATUS = 0
    BEGIN
        PRINT CONVERT(nvarchar, GETDATE(), 126) + '': Dropping autostats named '' + @objectname +''.'' + @statname
        SET @command = N''DROP STATISTICS '' +  @objectname + ''.'' + @statname;
        EXEC (@command)
        FETCH NEXT
        FROM
            statsToDrop
        INTO 
            @objectname, 
            @statname
        END
    CLOSE statsToDrop
    DEALLOCATE statsToDrop
    PRINT CONVERT(nvarchar, GETDATE(), 126) + '': Updating statistics on user tables (indicies and columns)''
    DECLARE tablesToRestat CURSOR FORWARD_ONLY READ_ONLY FOR 
    SELECT 
        o.object_id,
        quotename(o.name)
    FROM 
        sys.objects AS o
    WHERE 
        o.type = ''U''
    OPEN tablesToRestat
    FETCH NEXT
    FROM
        tablesToRestat
    INTO 
        @objectid, 
        @objectname
    WHILE @@FETCH_STATUS = 0
    BEGIN
        SELECT @bNeedFullScan = 0
        -- Lookup the name of the index
        SELECT 
            @schemaname = quotename(s.name)
        FROM 
            sys.objects AS o
        JOIN 
            sys.schemas AS s
        ON
            s.schema_id = o.schema_id
        WHERE
            o.object_id = @objectid
        IF (@bNeedFullScan = 1)
        BEGIN
            PRINT CONVERT(nvarchar, GETDATE(), 126) + '': Statistics for '' + @schemaname + ''.'' + @objectname + '' are now being updated with fullscan.''      
        END
        ELSE
        BEGIN
            PRINT CONVERT(nvarchar, GETDATE(), 126) + '': Statistics for '' + @schemaname + ''.'' + @objectname + '' are now being updated with default sampling.''
        END
        SELECT @command = 
            '' UPDATE STATISTICS '' +
                @schemaname + ''.'' + @objectname + '' WITH ALL, NORECOMPUTE '' 
        IF (@bNeedFullScan = 1)
        BEGIN
            SELECT @command += '', FULLSCAN''
        END
        PRINT CONVERT(nvarchar, GETDATE(), 126) + '': Rebuilding''
        EXEC (@command)
        PRINT CONVERT(nvarchar, GETDATE(), 126) + '': Done''
        FETCH NEXT FROM tablesToRestat INTO @objectid, @objectname
    END
    CLOSE tablesToRestat
    DEALLOCATE tablesToRestat
    PRINT CONVERT(nvarchar, GETDATE(), 126) + '': Done updating statistics''
    RETURN 0
' 
END
GO
