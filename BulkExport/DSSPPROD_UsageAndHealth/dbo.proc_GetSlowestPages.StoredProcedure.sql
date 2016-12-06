USE [DSSPPROD_UsageAndHealth]
GO
/****** Object:  StoredProcedure [dbo].[proc_GetSlowestPages]    Script Date: 11/10/2016 4:16:42 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[proc_GetSlowestPages]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[proc_GetSlowestPages]
   @StartTime           datetime = NULL,
   @EndTime             datetime = NULL,
   @WebApplicationId    uniqueIdentifier = NULL,
   @MachineName         nchar(128) = NULL, 
   @MaxRows             bigint = 100
AS
BEGIN
    SET NOCOUNT ON
    SELECT TOP(@MaxRows) 
         ServerUrl + 
         CASE  ISNULL(SiteUrl,'''')+ ISNULL(WebUrl,'''')
             WHEN ''/'' THEN '''' ELSE ISNULL(SiteUrl,'''')+ ISNULL(WebUrl,'''')
         END
         +ISNULL(DocumentPath,'''')
	     +ISNULL(QueryString,'''') AS Url,
        CONVERT(float,AVG(Duration))/1000 AS AverageDuration, 
        CONVERT(float,MAX(Duration))/1000 AS MaximumDuration,
        CONVERT(float,MIN(Duration))/1000 AS MinimumDuration, 
        AVG(QueryCount) AS AverageQueryCount,
        MAX(QueryCount) AS MaximumQueryCount,
        MIN(QueryCount) AS MinimumQueryCount,
        COUNT(*) AS TotalPageHits
    FROM dbo.RequestUsage
    WHERE PartitionId in (SELECT PartitionId from dbo.fn_PartitionIdRangeMonthly(@StartTime, @EndTime))
    AND  LogTime BETWEEN @StartTime AND @EndTime
    AND (@WebApplicationId IS NULL OR  WebApplicationId = @WebApplicationId)
    AND (@MachineName IS NULL or MachineName = @MachineName) 
    GROUP BY ServerUrl,SiteUrl,WebUrl,DocumentPath,QueryString
    ORDER BY AVG(duration) DESC
END
' 
END
GO
