USE [DSSPPROD_UsageAndHealth]
GO
/****** Object:  StoredProcedure [dbo].[proc_GetMostCPUIntensiveSQLQueries]    Script Date: 11/10/2016 4:16:42 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[proc_GetMostCPUIntensiveSQLQueries]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[proc_GetMostCPUIntensiveSQLQueries]
   @StartTime           datetime   = NULL,
   @EndTime             datetime   = NULL,
   @MachineName         nchar(128) = NULL, 
   @MaxRows             bigint = 100
AS
BEGIN
    SET NOCOUNT ON
    SELECT TOP(@MaxRows)
        PartitionId, 
        RowId, 
        LogTime, 
        MachineName, 
        Last_Execution_Time, 
        Execution_Count, 
        Average_IO, 
        Total_IO, 
        Average_CPU, 
        Total_Worker_Time, 
        Maximum_Worker_Time, 
        Total_Elapsed_Time, 
        Last_Worker_Time, 
        Database_Id, 
        Database_Name, 
        Object_Id, 
        Query_Text, 
        Query_Plan
    FROM dbo.SQLDMVQueries 
    WHERE PartitionId in (SELECT PartitionId from dbo.fn_PartitionIdRangeMonthly(@StartTime, @EndTime))
    AND LogTime BETWEEN @StartTime AND @EndTime
    AND (@MachineName IS NULL OR MachineName = @MachineName)
    ORDER BY Total_Elapsed_Time DESC
END
' 
END
GO
