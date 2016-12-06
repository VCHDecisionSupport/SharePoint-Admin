USE [DSSPPROD_UsageAndHealth]
GO
/****** Object:  StoredProcedure [dbo].[proc_AvgTimerJobImpactOnPageLatency]    Script Date: 11/10/2016 4:16:42 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[proc_AvgTimerJobImpactOnPageLatency]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[proc_AvgTimerJobImpactOnPageLatency]
	@MachineName nvarchar(128)= NULL,
	@StartTime datetime = NULL,
	@EndTime datetime = NULL,
        @MaxRows int = 100
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
	;WITH CTE1 (MachineName, JobTitle, StartTime, EndTime, JobDuration, AvgPageLatency)
	  AS
	  (
  	SELECT   
  	 tju.MachineName,  
	   tju.JobTitle,  
	   tju.StartTime,  
	   tju.EndTime,  
	   tju.Duration,  
	   avg(ru.Duration) as AvgPageLatency  
	FROM  
	     dbo.TimerJobUsage as tju WITH (NOLOCK)
	INNER JOIN #Partitions as p  
	      ON tju.PartitionID = p.PartitionID 
	LEFT JOIN  
		dbo.RequestUsage as ru WITH  (NOLOCK)
	ON  
		ru.PartitionID = tju.PartitionID 
		AND p.PartitionID = ru.PartitionID
	WHERE  
	   tju.StartTime >= @StartTime  
	   and tju.EndTime <= @EndTime  
	   and isnull(@MachineName, tju.MachineName) = tju.MachineName  
           and ru.LogTime BETWEEN tju.StartTime AND tju.EndTime
	GROUP BY   
	   tju.MachineName,  
	   tju.JobTitle,  
	   tju.StartTime,  
	   tju.EndTime,  
	   tju.Duration  
	 )  
 SELECT TOP (@MaxRows)
  MachineName,  
  JobTitle,   
  count(*) as TotalJobExecutions,
  avg(JobDuration) as AvgJobDuration,   
  avg(AvgPageLatency) as AvgPageLatency  
 FROM cte1  
 GROUP BY MachineName, JobTitle
 ORDER BY avg(AvgPageLatency) desc  
END
' 
END
GO
