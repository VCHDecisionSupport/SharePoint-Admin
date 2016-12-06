USE [DSSPPROD_UsageAndHealth]
GO
/****** Object:  StoredProcedure [dbo].[Search_GetRepositoryTimePerCrawl]    Script Date: 11/10/2016 4:16:42 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Search_GetRepositoryTimePerCrawl]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
        CREATE PROCEDURE [dbo].[Search_GetRepositoryTimePerCrawl]
            @CrawlID int,
            @CrawlDurationInMinutes int,
            @ContentSourceID int,
            @StartTime datetime,
            @EndTime datetime  
        AS
        BEGIN
            SELECT 
            ISNULL((SUM(RepositoryTime)/NULLIF(SUM(NumGetRequests + NumPostRequests),0)),0) As AverageRepositoryTime
            FROM Search_CrawlDocumentStats
            WHERE 
                CrawlId = @CrawlId 
                AND ContentSourceId = @ContentSourceID
                AND LogTime >= @StartTime
                AND LogTime < @EndTime
        END
    ' 
END
GO
