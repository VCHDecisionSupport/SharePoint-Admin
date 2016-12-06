USE [DSSPPROD_UsageAndHealth]
GO
/****** Object:  StoredProcedure [dbo].[proc_GetHighestResourceUtilizingQueries]    Script Date: 11/10/2016 4:16:42 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[proc_GetHighestResourceUtilizingQueries]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[proc_GetHighestResourceUtilizingQueries] 
   @StartTime           datetime   = NULL,
   @EndTime             datetime   = NULL,
   @MaxRows             bigint = 100
AS
BEGIN
    SET NOCOUNT ON
	IF (@StartTime is null)
		SELECT @StartTime = cast(convert(varchar(8), dateadd(dd, -3, getutcdate()), 1) as datetime)
	IF (@EndTime is null)
		SELECT @EndTime = getutcdate()
	CREATE TABLE #Partitions (PartitionId tinyint)
	INSERT INTO #Partitions (PartitionId) 
		SELECT PartitionId from dbo.fn_PartitionIdRangeMonthly(@StartTime, @EndTime)
	;with ThisHour (ExecDate, Database_Name, Query, AvgCPU, AvgIO, ExecCount)
	AS
	(
		select CONVERT(varchar(8), Last_Execution_Time, 1) + '' '' + LEFT(CONVERT(varchar(5), Last_Execution_Time, 8),3) + ''00'' as ExecDate,
		Database_Name,
		case when [object_name] is null then left(Query_Text, 1000) else [object_name] end as Query,
		max(Total_Worker_Time) as AvgCPU,
		max(Total_IO) as AvgIO,
		max(Execution_Count) as ExecCount
		from SQLDMVQueries
		WHERE Last_Execution_Time between @StartTime and @EndTime
		group by 
		CONVERT(varchar(8), Last_Execution_Time, 1) + '' '' + LEFT(CONVERT(varchar(5), Last_Execution_Time, 8),3) + ''00'',
		Database_Name,
		case when [object_name] is null then left(Query_Text, 1000) else [object_name] end 
	)
	,LastHour (ExecDate2, Database_Name2, Query2, AvgCPU2, AvgIO2, ExecCount2)
	AS
	(
		select CONVERT(varchar(8), Last_Execution_Time, 1) + '' '' + LEFT(CONVERT(varchar(5), Last_Execution_Time, 8),3) + ''00'' as ExecDate,
		Database_Name,
		case when [object_name] is null then left(Query_Text, 1000) else [object_name] end as Query,
		max(Total_Worker_Time) as AvgCPU,
		max(Total_IO) as AvgIO,
		max(Execution_Count) as ExecCount
		from SQLDMVQueries
		WHERE Last_Execution_Time between dateadd(hh, -1, @StartTime) and dateadd(hh, -1, @EndTime)
		group by 
		CONVERT(varchar(8), Last_Execution_Time, 1) + '' '' + LEFT(CONVERT(varchar(5), Last_Execution_Time, 8),3) + ''00'',
		Database_Name,
		case when [object_name] is null then left(Query_Text, 1000) else [object_name] end 
	)
	select TOP (@MaxRows)
		ExecDate,
		Database_Name,
		Query,
		ExecCount-isnull(ExecCount2,0) as ExecutionCount,
		(AvgCPU - CASE WHEN AvgCPU2 > AvgCPU THEN AvgCPU ELSE isnull(AvgCPU2,0) END) as TotalCPUCost,
		(AvgIO - isnull(AvgIO2, 0)) as TotalIOCost
	FROM ThisHour
	LEFT JOIN LastHour
		ON ThisHour.Query = LastHour.Query2
		AND CONVERT(datetime, ThisHour.ExecDate) = dateadd(hh, 1, CONVERT(datetime,LastHour.ExecDate2))
		AND isnull(ThisHour.Database_Name,'''') = isnull(LastHour.Database_Name2,'''')
	order by 
		ExecDate,
		Query
END
' 
END
GO
