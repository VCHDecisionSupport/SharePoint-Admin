USE [DSSPPROD_UsageAndHealth]
GO
/****** Object:  StoredProcedure [dbo].[Search_GetCrawlPipeline]    Script Date: 11/10/2016 4:16:42 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Search_GetCrawlPipeline]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
    CREATE PROCEDURE [dbo].[Search_GetCrawlPipeline]
        @applicationId uniqueIdentifier,
        @startDate datetime,
        @endDate datetime
    AS
        SELECT * FROM Search_CrawlWorkerTimings
        WHERE (@applicationId = ''00000000-0000-0000-0000-000000000000'' OR ApplicationId = @applicationId) AND
        LogTime <= @EndDate AND
        LogTime >= @StartDate
' 
END
GO
