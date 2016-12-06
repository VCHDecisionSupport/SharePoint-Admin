USE [DSSPPROD_UsageAndHealth]
GO
/****** Object:  StoredProcedure [dbo].[prc_EnumSqlLatencyData]    Script Date: 11/10/2016 4:16:42 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[prc_EnumSqlLatencyData]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[prc_EnumSqlLatencyData]  
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
        SELECT TOP(@RowsToReturn) n.* FROM [dbo].[SqlLatencyData] as n WITH (NOLOCK)
        INNER JOIN #Partitions as p
        ON p.PartitionId = n.PartitionId
        WHERE LogTime BETWEEN @BeginTime and @EndTime    
        AND ISNULL(@MachineName, MachineName) = MachineName
        ORDER BY n.PartitionId desc, n.LogTime desc
    END' 
END
GO
