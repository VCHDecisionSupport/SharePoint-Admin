USE [DSSPPROD_UsageAndHealth]
GO
/****** Object:  StoredProcedure [dbo].[Search_GetCPUUsage]    Script Date: 11/10/2016 4:16:42 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Search_GetCPUUsage]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
    CREATE PROCEDURE [dbo].[Search_GetCPUUsage]
        @startDate datetime,
        @endDate datetime,
        @machineName nvarchar(128)
    AS
    BEGIN
     
    SELECT Max(LogTime) As LogTime,
           AVG(TimerCPU) As TimerCPU,
           AVG(MssearchCPU) As MssearchCPU,
           AVG(MssdmnCPU) As MssdmnCPU,
           AVG(NoderunnerCPU) As NoderunnerCPU
    FROM Search_SystemMetrics
    WHERE
           LogTime <= @EndDate AND
           LogTime >= @StartDate AND
           (@machineName = ''00000000-0000-0000-0000-000000000000'' OR MachineName = @machineName)
    GROUP BY
        DATEPART(yy, LogTime),  DATEPART(mm, LogTime),  DATEPART(dd, LogTime), DATEPART(hh, LogTime), DATEPART(mi, LogTime)    
    ORDER BY DATEPART(yy, LogTime),  DATEPART(mm, LogTime),  DATEPART(dd, LogTime), DATEPART(hh, LogTime), DATEPART(mi, LogTime)
    END
' 
END
GO
