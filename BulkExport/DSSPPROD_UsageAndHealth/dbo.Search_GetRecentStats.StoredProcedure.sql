USE [DSSPPROD_UsageAndHealth]
GO
/****** Object:  StoredProcedure [dbo].[Search_GetRecentStats]    Script Date: 11/10/2016 4:16:42 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Search_GetRecentStats]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
    CREATE PROCEDURE [dbo].[Search_GetRecentStats]
        @applicationId uniqueIdentifier
    AS
        SELECT MAX(LogTime) AS MaxLogTime, MIN(LogTime) AS MinLogTime, SUM(NumQueries) AS QueryCount
        FROM Search_PerMinuteTotalOMQueryLatency 
        WHERE
            ApplicationId = @applicationId AND
            LogTime <= DATEADD(minute, -1, GETUTCDATE()) AND LogTime > DATEADD(minute, -16, GETUTCDATE())

        SELECT MAX(LogTime) AS MaxLogTime, MIN(LogTime) AS MinLogTime, SUM(NumDocuments) AS NumDocuments
        FROM Search_CrawlDocumentStats
        WHERE 
            ApplicationId = @applicationId AND
            LogTime <= DATEADD(minute, -1, GETUTCDATE()) AND LogTime > DATEADD(minute, -16, GETUTCDATE())
' 
END
GO
