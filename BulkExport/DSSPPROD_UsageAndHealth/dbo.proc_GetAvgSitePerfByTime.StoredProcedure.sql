USE [DSSPPROD_UsageAndHealth]
GO
/****** Object:  StoredProcedure [dbo].[proc_GetAvgSitePerfByTime]    Script Date: 11/10/2016 4:16:42 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[proc_GetAvgSitePerfByTime]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[proc_GetAvgSitePerfByTime]
   @Url varchar(260) = '''',
   @StartTime datetime = NULL,
   @EndTime datetime = NULL,
   @MachineName nvarchar(128)= NULL
AS
BEGIN
	SET NOCOUNT ON
	IF (@StartTime is null)
		SELECT @StartTime = cast(convert(varchar(8), dateadd(dd, -3, getdate()), 1) as datetime)
	IF (@EndTime is null)
		SELECT @EndTime = getdate()
   	CREATE TABLE #Partitions (PartitionId tinyint)
	INSERT INTO #Partitions (PartitionId) 
		SELECT PartitionId from dbo.fn_PartitionIdRangeMonthly(@StartTime, @EndTime)
	--CREATE INDEX IX_Partition on #Partitions (PartitionID)
	DECLARE @Results TABLE (Hour varchar(16))
	DECLARE @DateValue datetime
	SELECT @DateValue = @StartTime
	WHILE (@DateValue < @EndTime)
	BEGIN
		INSERT INTO @Results SELECT cast(datepart(month, @DateValue) as varchar) + ''/'' +
			cast(datepart(day, @DateValue) as varchar) + ''/'' +			
			cast(datepart(year, @DateValue) as varchar) + '' '' +
			cast(datepart(hour, @DateValue) as varchar) + '':00''
		SELECT @DateValue = DATEADD(hh, 1, @DateValue)
	END
	select 
		cast(datepart(month, LogTime) as varchar(2)) + ''/'' +
			cast(datepart(day, LogTime) as varchar(2)) + ''/'' +			
			cast(datepart(year, LogTime) as varchar(4)) + '' '' +
			cast(datepart(hour, LogTime) as varchar(2)) + '':00'' as Hour,
		CAST(CASE WHEN charindex(''/'', SiteUrl, len(''http://'')+1) > 0
			THEN LEFT(SiteUrl, charindex(''/'', SiteUrl, len(''http://'')+1)-1)
			ELSE SiteUrl END AS varchar(50)) as Site,
		avg(Duration) as AvgDuration,
		max(Duration) as MaxDuration,
		count(*) as TotalPageHits,
		count(distinct CorrelationId) as UniqueRequests
	INTO #ReturnTable
	from dbo.RequestUsage as t WITH (NOLOCK)
	inner join #Partitions as p
		on t.PartitionID = p.PartitionID
	where LogTime between @StartTime and @EndTime
	and SiteUrl like @Url + ''%''
	and isnull(@MachineName,MachineName) = MachineName
	group by cast(datepart(month, LogTime) as varchar(2)) + ''/'' +
			cast(datepart(day, LogTime) as varchar(2)) + ''/'' +			
			cast(datepart(year, LogTime) as varchar(4)) + '' '' +
			cast(datepart(hour, LogTime) as varchar(2)) + '':00'',
			CAST(CASE WHEN charindex(''/'', SiteUrl, len(''http://'')+1) > 0
			THEN LEFT(SiteUrl, charindex(''/'', SiteUrl, len(''http://'')+1)-1)
			ELSE SiteUrl END AS varchar(50)) 
	INSERT INTO #ReturnTable
	SELECT Hour, '''', 0, 0, 0, 0
	FROM @Results as r
	WHERE NOT EXISTS (
		select Hour 
		from #ReturnTable
		where r.Hour = #ReturnTable.Hour
	)
	SELECT * 
	FROM #ReturnTable
	ORDER BY CAST(Hour as datetime) ASC
END
' 
END
GO
