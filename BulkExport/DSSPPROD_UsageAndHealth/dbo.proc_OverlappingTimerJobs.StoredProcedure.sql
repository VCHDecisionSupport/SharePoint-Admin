USE [DSSPPROD_UsageAndHealth]
GO
/****** Object:  StoredProcedure [dbo].[proc_OverlappingTimerJobs]    Script Date: 11/10/2016 4:16:42 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[proc_OverlappingTimerJobs]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[proc_OverlappingTimerJobs]
	@MachineName nvarchar(128) = NULL,
	@StartTime datetime = NULL,
	@EndTime datetime = NULL,
	@OverlappingDurationMs int = 1000
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
	SELECT 
		tju.MachineName,
		tju.JobTitle,
		tju.StartTime,
		tju.EndTime,
		tju.Duration,
		COUNT(tju2.JobId) as NumJobs
	FROM
		dbo.TimerJobUsage as tju
	INNER JOIN
		dbo.TimerJobUsage as tju2
	ON
		tju.StartTime BETWEEN tju2.StartTime AND tju2.EndTime
	INNER JOIN #Partitions as p
		ON tju.PartitionID = p.PartitionID
	WHERE
		tju.StartTime >= @StartTime
		AND tju.EndTime <= @EndTime
		AND tju.JobID <> tju2.JobID
		AND tju.MachineName = tju2.MachineName
		and isnull(@MachineName, tju.MachineName) = tju.MachineName
		and datediff(ms, tju.StartTime, case when tju.EndTime > tju2.EndTime then tju2.EndTime else tju.EndTime end) > @OverlappingDurationMs
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
