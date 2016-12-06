USE [DSSPPROD_UsageAndHealth]
GO
/****** Object:  StoredProcedure [dbo].[proc_TimerJobImpactOnPageLatency]    Script Date: 11/10/2016 4:16:42 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[proc_TimerJobImpactOnPageLatency]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[proc_TimerJobImpactOnPageLatency]
	@MachineName nvarchar(128)= NULL,
	@StartTime datetime = NULL,
	@EndTime datetime = NULL
AS
BEGIN
	SET NOCOUNT ON
	IF (@StartTime is null)
		SELECT @StartTime = cast(convert(varchar(8), dateadd(hour, -3, getutcdate()), 1) as datetime)
	IF (@EndTime is null)
		SELECT @EndTime = getutcdate()
	CREATE TABLE #Partitions (PartitionId tinyint)
	INSERT INTO #Partitions (PartitionId) 
		SELECT PartitionId from dbo.fn_PartitionIdRangeMonthly(@StartTime, @EndTime)
	SELECT 
		tju.MachineName,
		tju.JobTitle,
		tju.StartTime,
		tju.EndTime,
		tju.Duration,
		avg(ru.Duration) as AvgPageLatency,
		min(ru.Duration) as MinPageLatency,
		max(ru.Duration) as MaxPageLatency
	FROM
		dbo.TimerJobUsage as tju
	INNER JOIN #Partitions as p
		ON tju.PartitionID = p.PartitionID
	LEFT JOIN
		dbo.RequestUsage as ru
	ON
		ru.PartitionID = tju.PartitionID 
	AND p.PartitionID = ru.PartitionID
	WHERE
		tju.StartTime >= @StartTime
		and tju.EndTime <= @EndTime
		and isnull(@MachineName, tju.MachineName) = tju.MachineName
		and ru.LogTime BETWEEN tju.StartTime AND tju.EndTime	
		and tju.Duration > 100 
		and ru.Duration is not null
	GROUP BY 
		tju.MachineName,
		tju.JobTitle,
		tju.StartTime,
		tju.EndTime,
		tju.Duration
	ORDER BY tju.StartTime
END
' 
END
GO
