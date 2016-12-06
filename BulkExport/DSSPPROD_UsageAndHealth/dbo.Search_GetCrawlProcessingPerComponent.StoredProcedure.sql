USE [DSSPPROD_UsageAndHealth]
GO
/****** Object:  StoredProcedure [dbo].[Search_GetCrawlProcessingPerComponent]    Script Date: 11/10/2016 4:16:42 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Search_GetCrawlProcessingPerComponent]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
    CREATE PROCEDURE [dbo].[Search_GetCrawlProcessingPerComponent]
        @applicationId uniqueIdentifier,
        @startDate datetime,
        @endDate datetime
    AS
        SELECT 
            LogTime,
            SUM(ThrdsBindToFilterSTS3 + ThrdsGetStandardPropertiesSTS3 + ThrdsDataFromFDProtocolsSTS3) / 1000 AS Sts3PhTotal,
            SUM(ThrdsBindToFilterSTS4 + ThrdsGetStandardPropertiesSTS4 + ThrdsDataFromFDProtocolsSTS4) / 1000 AS Sts4PhTotal,
            SUM(ThrdsBindToFilterFILE + ThrdsGetStandardPropertiesFILE + ThrdsDataFromFDProtocolsFILE) / 1000 AS FilePhTotal,
            SUM(ThrdsBindToFilterHTTP + ThrdsGetStandardPropertiesHTTP + ThrdsDataFromFDProtocolsHTTP) / 1000 AS HttpPhTotal,
            SUM(ThrdsWait) / 1000 AS WaitTotal,
            SUM(ThrdsFilterDriverInit) / 1000 AS FilterInitializationTotal,
            SUM(ThrdsBindToFilterSPS + ThrdsGetStandardPropertiesSPS + ThrdsDataFromFDProtocolsSPS) / 1000 AS SpsPhTotal,
            SUM(ThrdsPluginsOnDataChangeFeatureExtraction + ThrdsPluginsChunkProcessingFeatureExtraction + ThrdsPluginsProcessWordsFeatureExtraction + ThrdsPluginsAddCompletedFeatureExtraction) / 1000 AS FeatureExtractionPluginTotal,
            SUM(ThrdsPluginsOnDataChangeIndexer + ThrdsPluginsChunkProcessingIndexer + ThrdsPluginsProcessWordsIndexer + ThrdsPluginsAddCompletedIndexer) / 1000 AS IndexerPluginTotal,
            SUM(ThrdsPluginsOnDataChangeMatrix + ThrdsPluginsChunkProcessingMatrix + ThrdsPluginsProcessWordsMatrix + ThrdsPluginsAddCompletedMatrix) / 1000 AS MatrixPluginTotal,
            SUM(ThrdsPluginsOnDataChangeArpi + ThrdsPluginsChunkProcessingArpi + ThrdsPluginsProcessWordsArpi + ThrdsPluginsAddCompletedArpi) / 1000 AS ArpiPluginTotal,
            SUM(ThrdsPluginsOnDataChangeGatherer + ThrdsPluginsChunkProcessingGatherer + ThrdsPluginsProcessWordsGatherer + ThrdsPluginsAddCompletedGatherer) / 1000 AS GathererTotal,
            SUM(ThrdsBindToFilterBDC + ThrdsGetStandardPropertiesBDC + ThrdsDataFromFDProtocolsBDC) / 1000 AS BdcPhTotal,
            SUM(ThrdsBindToFilterNOTES + ThrdsGetStandardPropertiesNOTES + ThrdsDataFromFDProtocolsNOTES) / 1000 AS LotusPhTotal,
            SUM(ThrdsBindToFilterOTHER + ThrdsGetStandardPropertiesOTHER + ThrdsDataFromFDProtocolsOTHER) / 1000 AS OtherPhTotal,
            SUM(ThrdsDataFromFDIFilter) / 1000 AS FilterPhTotal,
            SUM(ThrdsWordBreaking) / 1000 AS WordBreakerTotal,
            SUM(ThrdsPluginsOnDataChangeScopes + ThrdsPluginsChunkProcessingScopes + ThrdsPluginsProcessWordsScopes + ThrdsPluginsAddCompletedScopes) / 1000 AS ScopesPluginTotal,
            SUM(ThrdsPluginsOnDataChangeAnchor + ThrdsPluginsChunkProcessingAnchor + ThrdsPluginsProcessWordsAnchor + ThrdsPluginsAddCompletedAnchor) / 1000 AS AnchorTotal,
            SUM(ThrdsPluginsOnDataChangeOther + ThrdsPluginsChunkProcessingOther + ThrdsPluginsProcessWordsOther + ThrdsPluginsAddCompletedOther + ThrdsPluginsOnDataChangeSimplePI + ThrdsPluginsChunkProcessingSimplePI + ThrdsPluginsProcessWordsSimplePI + ThrdsPluginsAddCompletedSimplePI) / 1000 AS OtherTotal
        FROM Search_CrawlWorkerTimings
        WHERE (@applicationId = ''00000000-0000-0000-0000-000000000000'' OR ApplicationId = @applicationId) AND
            LogTime <= @EndDate AND
            LogTime >= @StartDate
        GROUP BY LogTime
        ORDER BY LogTime' 
END
GO
