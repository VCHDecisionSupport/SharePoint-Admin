USE [DSSPPROD_UsageAndHealth]
GO
/****** Object:  StoredProcedure [dbo].[proc_GetSlowestPageRequests]    Script Date: 11/10/2016 4:16:42 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[proc_GetSlowestPageRequests]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[proc_GetSlowestPageRequests]
   @Url varchar(260) = '''',
   @StartTime datetime = NULL,
   @EndTime datetime = NULL
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
	select SiteUrl + isnull(WebUrl,'''') + isnull(DocumentPath,'''') + isnull(QueryString,'''') as Url, p.* 
	FROM dbo.RequestUsage as t
	INNER JOIN #Partitions as p
		ON t.PartitionID = p.PartitionID
	where [LogTime] between @StartTime and @EndTime
	and SiteUrl like @Url + ''%''
	order by Duration desc
END
' 
END
GO
