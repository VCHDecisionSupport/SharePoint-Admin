USE [DSSPPROD_UsageAndHealth]
GO
/****** Object:  StoredProcedure [dbo].[proc_GetMostActiveUsers]    Script Date: 11/10/2016 4:16:42 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[proc_GetMostActiveUsers]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[proc_GetMostActiveUsers]
   @StartTime               datetime     = NULL,
   @EndTime                 datetime     = NULL,
   @WebApplicationId        uniqueIdentifier = NULL, 
   @MachineName             nchar(128)   = NULL,
   @MaxRows                 bigint = 100
AS
BEGIN
    SET NOCOUNT ON
    SELECT
     TOP(@MaxRows)
     UserLogin AS [User],
     COUNT(RowId) AS Hits,
     MAX(LogTime) AS LastAccessTime,
     CONVERT(float,SUM(CASE WHEN HttpStatus<400 THEN 1 ELSE 0 END))/CONVERT(float,COUNT(RowId)) AS SuccessRate
    FROM [dbo].[RequestUsage]
    WHERE  PartitionId in (SELECT PartitionId from dbo.fn_PartitionIdRangeMonthly(@StartTime, @EndTime)) 
    AND LogTime BETWEEN @StartTime AND @EndTime
    AND (@WebApplicationId IS NULL OR  WebApplicationId = @WebApplicationId)
    AND (@MachineName IS NULL or MachineName = @MachineName)
    AND UserLogin IS NOT NULL 
    AND DataLength(UserLogin)>0
    GROUP BY
        UserLogIn
    ORDER BY
        Count(RowId) DESC
END
' 
END
GO
