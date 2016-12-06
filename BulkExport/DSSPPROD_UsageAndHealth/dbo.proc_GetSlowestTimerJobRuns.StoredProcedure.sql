USE [DSSPPROD_UsageAndHealth]
GO
/****** Object:  StoredProcedure [dbo].[proc_GetSlowestTimerJobRuns]    Script Date: 11/10/2016 4:16:42 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[proc_GetSlowestTimerJobRuns]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[proc_GetSlowestTimerJobRuns]
   @StartTime   datetime = NULL,
   @EndTime     datetime = NULL,
   @MachineName nvarchar(128) = NULL,
   @MaxRows     bigint = 100
AS
BEGIN
    SET NOCOUNT ON
    SELECT TOP (@MaxRows) 
        JobTitle, 
        Duration, 
        LogTime, 
        MachineName,
        SiteSubscriptionId, 
        UserLogin, 
        CorrelationId, 
        ServiceId, 
        WebApplicationId, 
        JobId, 
        ServerId, 
        Status, 
        StartTime, 
        EndTime, 
        WebApplicationName, 
        RequestCount, 
        QueryCount
    FROM dbo.TimerJobUsage
    WHERE PartitionId in (SELECT PartitionId from dbo.fn_PartitionIdRangeMonthly(@StartTime, @EndTime))
    AND LogTime BETWEEN @StartTime AND @EndTime
    AND (@MachineName IS NULL or MachineName = @MachineName) 
    ORDER BY Duration desc
END
' 
END
GO
