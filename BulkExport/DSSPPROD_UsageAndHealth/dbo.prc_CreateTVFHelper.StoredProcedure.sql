USE [DSSPPROD_UsageAndHealth]
GO
/****** Object:  StoredProcedure [dbo].[prc_CreateTVFHelper]    Script Date: 11/10/2016 4:16:41 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[prc_CreateTVFHelper]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[prc_CreateTVFHelper]
(
    @TypeName nvarchar(100),
    @Column sysname,
    @InputParameters nvarchar(4000),
    @IndexName sysname,
    @IndexFilter nvarchar(4000),
    @Debug bit = 0 
)
AS
BEGIN
    DECLARE @SQL nvarchar(max), 
            @Counter tinyint,
            @MaxPartitions tinyint
        --Clear the TVF first if it exists    
        exec dbo.prc_CleanTVFHelper @TypeName,@Column,@Debug    
        SET @MaxPartitions = 31 + 1
        SET @Counter = 0
        SET @SQL=''CREATE FUNCTION [dbo].[TVF_''+@TypeName+''_''+@Column+''](''+@InputParameters+
         '') RETURNS TABLE AS RETURN WITH CTEALL AS (''
        WHILE (@Counter < @MaxPartitions)
        BEGIN
            IF (@Counter > 0)
                SET @SQL = @SQL + '' UNION ALL ''
            SELECT @SQL = @SQL + 
                '' SELECT * FROM '' + 
                ''[dbo].['' + @TypeName + ''_Partition'' + cast(@Counter as nvarchar) + '']''+
                '' WITH(NOLOCK, INDEX=''+
                @IndexName+'') WHERE '' +@IndexFilter
            SET @Counter = @Counter+1
        END
        SET @SQL=@SQL+'') SELECT * FROM CTEALL''
        IF (@Debug = 1)
            PRINT @SQL
        ELSE
            exec sp_executesql @SQL
END
' 
END
GO
