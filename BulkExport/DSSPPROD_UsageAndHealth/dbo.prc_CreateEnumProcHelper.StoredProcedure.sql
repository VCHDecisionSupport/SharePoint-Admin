USE [DSSPPROD_UsageAndHealth]
GO
/****** Object:  StoredProcedure [dbo].[prc_CreateEnumProcHelper]    Script Date: 11/10/2016 4:16:41 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[prc_CreateEnumProcHelper]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[prc_CreateEnumProcHelper]
(
    @TypeName nvarchar(100),
    @Debug bit = 0
)
AS
BEGIN
    DECLARE @SQL nvarchar(MAX),
        @Params nvarchar(1200),
        @ColumnName sysname,
        @TableName sysname,
        @ProcName sysname,
        @Exists bit
    SET NOCOUNT ON
    SELECT @TableName = @TypeName + ''_Partition0''
    SELECT @ProcName = ''prc_Enum'' + @TypeName
    IF (object_id(@ProcName) IS NOT NULL)
        SET @Exists = 1
    ELSE
        SET @Exists = 0
    SELECT @SQL = CASE WHEN @Exists = 1 THEN ''ALTER'' ELSE ''CREATE'' END 
        + '' PROCEDURE '' + ''[dbo].['' + @ProcName + '']'' + ''  
        @BeginTime datetime = NULL,
        @EndTime datetime = NULL,
        @MachineName nvarchar(128) = NULL,
        @RowsToReturn smallint = 1000
    AS
    BEGIN
        SET NOCOUNT ON
        CREATE TABLE #Partitions (PartitionId tinyint)
        IF (@BeginTime IS NULL)
            SELECT @BeginTime = dateadd(hh, -1, getutcdate())
        IF (@EndTime IS NULL)
            SELECT @EndTime = getutcdate()
        -- Validate date range    
        INSERT INTO #Partitions (PartitionId) 
            SELECT PartitionId from dbo.fn_PartitionIdRangeMonthly(@BeginTime, @EndTime)
        SELECT TOP(@RowsToReturn) n.* '' +
        ''FROM '' + ''[dbo].['' + @TypeName + '']'' + '' as n WITH (NOLOCK)
        INNER JOIN #Partitions as p
        ON p.PartitionId = n.PartitionId
        WHERE LogTime BETWEEN @BeginTime and @EndTime    
        AND ISNULL(@MachineName, MachineName) = MachineName
        ORDER BY n.PartitionId desc, n.LogTime desc
    END''
    IF (@Debug = 1)
        PRINT @SQL
    ELSE
    BEGIN
        exec sp_executesql @SQL
	exec sp_recompile @ProcName
    END
END
' 
END
GO
