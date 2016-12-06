USE [DSSPPROD_UsageAndHealth]
GO
/****** Object:  StoredProcedure [dbo].[Search_GetCrawlProcessingPerActivity]    Script Date: 11/10/2016 4:16:42 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Search_GetCrawlProcessingPerActivity]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
    CREATE PROCEDURE [dbo].[Search_GetCrawlProcessingPerActivity]
        @applicationId uniqueIdentifier,
        @startDate datetime,
        @endDate datetime
    AS
        SELECT 
            LogTime,
            SUM(ThrdsDataFromFDProtocolsFILE + ThrdsDataFromFDProtocolsHTTP + ThrdsDataFromFDProtocolsSTS3 + ThrdsDataFromFDProtocolsSTS4 + ThrdsDataFromFDProtocolsSPS + ThrdsDataFromFDProtocolsBDC + ThrdsDataFromFDProtocolsNOTES + ThrdsDataFromFDProtocolsRANKING + ThrdsDataFromFDProtocolsOTHER) / 1000 AS ProtocolHandlersTotal,
            SUM(ThrdsGetStandardPropertiesFILE + ThrdsGetStandardPropertiesHTTP + ThrdsGetStandardPropertiesSTS3 + ThrdsGetStandardPropertiesSTS4 + ThrdsGetStandardPropertiesSPS + ThrdsGetStandardPropertiesBDC + ThrdsGetStandardPropertiesNOTES + ThrdsGetStandardPropertiesRANKING + ThrdsGetStandardPropertiesOTHER) / 1000 AS StandardPropertiesTotal,
            SUM(ThrdsFilterDriverInit + ThrdsBindToFilterFILE + ThrdsBindToFilterHTTP + ThrdsBindToFilterSTS3 + ThrdsBindToFilterSTS4 + ThrdsBindToFilterSPS + ThrdsBindToFilterBDC + ThrdsBindToFilterNOTES + ThrdsBindToFilterRANKING + ThrdsBindToFilterOTHER) / 1000 AS FilterInitializationTotal,
            SUM(ThrdsWait) / 1000 AS WaitTotal,
            SUM(ThrdsDataFromFDIFilter) / 1000 AS FilteringTotal,
            SUM(ThrdsWordBreaking) / 1000 AS WordBreakingTotal,
            SUM(ThrdsPluginsOnDataChangeIndexer + ThrdsPluginsOnDataChangeArpi + ThrdsPluginsOnDataChangeFeatureExtraction + ThrdsPluginsOnDataChangeMatrix + ThrdsPluginsOnDataChangeScopes + ThrdsPluginsOnDataChangeAnchor + ThrdsPluginsOnDataChangeSimplePI + ThrdsPluginsOnDataChangeGatherer + ThrdsPluginsOnDataChangeOther) / 1000 AS OnDataChangeTotal,
            SUM(ThrdsPluginsChunkProcessingIndexer + ThrdsPluginsChunkProcessingArpi + ThrdsPluginsChunkProcessingFeatureExtraction + ThrdsPluginsChunkProcessingMatrix + ThrdsPluginsChunkProcessingScopes + ThrdsPluginsChunkProcessingAnchor + ThrdsPluginsChunkProcessingSimplePI + ThrdsPluginsChunkProcessingGatherer + ThrdsPluginsChunkProcessingOther) / 1000 AS ChunkProcessingTotal,
            SUM(ThrdsPluginsProcessWordsIndexer + ThrdsPluginsProcessWordsArpi + ThrdsPluginsProcessWordsFeatureExtraction + ThrdsPluginsProcessWordsMatrix + ThrdsPluginsProcessWordsScopes + ThrdsPluginsProcessWordsAnchor + ThrdsPluginsProcessWordsSimplePI + ThrdsPluginsProcessWordsGatherer + ThrdsPluginsProcessWordsOther) / 1000 AS ProcessWordsTotal,
            SUM(ThrdsPluginsAddCompletedIndexer + ThrdsPluginsAddCompletedArpi + ThrdsPluginsAddCompletedFeatureExtraction + ThrdsPluginsAddCompletedMatrix + ThrdsPluginsAddCompletedScopes + ThrdsPluginsAddCompletedAnchor + ThrdsPluginsAddCompletedSimplePI + ThrdsPluginsAddCompletedGatherer + ThrdsPluginsAddCompletedOther) / 1000 AS AddCompletedTotal
        FROM Search_CrawlWorkerTimings
        WHERE (@applicationId = ''00000000-0000-0000-0000-000000000000'' OR ApplicationId = @applicationId) AND
            LogTime <= @EndDate AND
            LogTime >= @StartDate
        GROUP BY LogTime
        ORDER BY LogTime' 
END
GO
