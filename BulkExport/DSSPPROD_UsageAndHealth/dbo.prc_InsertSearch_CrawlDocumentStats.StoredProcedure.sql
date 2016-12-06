USE [DSSPPROD_UsageAndHealth]
GO
/****** Object:  StoredProcedure [dbo].[prc_InsertSearch_CrawlDocumentStats]    Script Date: 11/10/2016 4:16:42 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[prc_InsertSearch_CrawlDocumentStats]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[prc_InsertSearch_CrawlDocumentStats]    
        @ApplicationId uniqueidentifier, @CrawlComponentId int, @CrawlId int, @ContentSourceId int, @NumDocuments bigint, @IsHighPriority int, @RepositoryTime bigint, @ProtocolHandlerTime bigint, @Filtering bigint, @CTSTime bigint, @SQLTime bigint, @GathererTime bigint, @TimeSpentInLinksTable bigint, @TimeSpentInQueue bigint, @ActionAddModify int, @ActionDelete int, @ActionSecurityOnly int, @ActionNoIndex int, @ActionNotModified int, @ActionSingleThreadedFD int, @ActionError int, @ActionRetry int, @ActionOther int, @LessThan15Min int, @LessThan30Min int, @LessThan1Hour int, @LessThan4Hours int, @LessThan1Day int, @LessThan1Week int, @LessThan1Month int, @GreaterThan1Month int, @ApplicationName nvarchar(1024), @ContentSourceName nvarchar(1024), @ThreadWaitingTime bigint, @NumGetRequests bigint, @NumPostRequests bigint, @DiscoveryTime bigint, @CTSTimeFromContentPipeline bigint, @IndexerTimeFromContentPipeline bigint, @LessThan2Min int, @LessThan5Min int, @LessThan10Min int, @LessThan20Min int, @LessThan45Min int, @LessThan2Hours int, @LessThan8Hours int, @LessThan12Hours int, @LessThan2Days int, @LessThan3Days int, @HybridParserTime bigint, @SPOTime bigint,         
        @MachineName nvarchar(128),
        @LogTime datetime 
    AS
    BEGIN
        SET NOCOUNT ON
        DECLARE @PartitionId tinyint,
                @UTCDate datetime,
                @ConfigName nvarchar(255),
                @RetentionPeriod smallint,
		@MaxBytes bigint
        SELECT @UTCDate = getutcdate()
        -- We probably want to discard anything older than retention policy
        -- and messages from the future should be similarly ignored
        -- Just ignore without error
        SELECT @ConfigName = ''Retention Period - Search_CrawlDocumentStats''
        SELECT @RetentionPeriod = CAST(dbo.fn_GetConfigValue(@ConfigName)  as smallint)
        IF (datediff(dd, @LogTime, @UTCDate) > @RetentionPeriod OR
            datediff(hh, @LogTime, @UTCDate) < 0)
        BEGIN
            RETURN
        END
	SELECT @ConfigName = ''Max Total Bytes - Search_CrawlDocumentStats''
	SELECT @MaxBytes = CAST(dbo.fn_GetConfigValue(@ConfigName) as bigint) / @RetentionPeriod
        SELECT @PartitionId = dbo.fn_GetPartitionId(@LogTime)
        exec dbo.prc_LogAndRollOverPartition ''Search_CrawlDocumentStats'', @UTCDate 
		-- Silently fail if the partition is full.
		IF (dbo.fn_GetPartitionSize(''Search_CrawlDocumentStats_Partition'' + CAST(@PartitionId as NVARCHAR(MAX))) >= @MaxBytes)
		BEGIN
			RETURN
		END
        DECLARE @SQL nvarchar(MAX), 
		        @SQLParams nvarchar(MAX)
        SELECT @SQL =
	           CAST(''INSERT INTO [dbo].[Search_CrawlDocumentStats_Partition'' AS NVARCHAR(MAX)) + CAST(@PartitionId as NVARCHAR(MAX)) + CAST('']
			        (PartitionId, 
			        LogTime,
			        MachineName,
                ApplicationId, CrawlComponentId, CrawlId, ContentSourceId, NumDocuments, IsHighPriority, RepositoryTime, ProtocolHandlerTime, Filtering, CTSTime, SQLTime, GathererTime, TimeSpentInLinksTable, TimeSpentInQueue, ActionAddModify, ActionDelete, ActionSecurityOnly, ActionNoIndex, ActionNotModified, ActionSingleThreadedFD, ActionError, ActionRetry, ActionOther, LessThan15Min, LessThan30Min, LessThan1Hour, LessThan4Hours, LessThan1Day, LessThan1Week, LessThan1Month, GreaterThan1Month, ApplicationName, ContentSourceName, ThreadWaitingTime, NumGetRequests, NumPostRequests, DiscoveryTime, CTSTimeFromContentPipeline, IndexerTimeFromContentPipeline, LessThan2Min, LessThan5Min, LessThan10Min, LessThan20Min, LessThan45Min, LessThan2Hours, LessThan8Hours, LessThan12Hours, LessThan2Days, LessThan3Days, HybridParserTime, SPOTime, 
			        RowCreatedTime) 
		        SELECT 
			        @PartitionId,
			        @LogTime,
			        @MachineName,
                @ApplicationId, @CrawlComponentId, @CrawlId, @ContentSourceId, @NumDocuments, @IsHighPriority, @RepositoryTime, @ProtocolHandlerTime, @Filtering, @CTSTime, @SQLTime, @GathererTime, @TimeSpentInLinksTable, @TimeSpentInQueue, @ActionAddModify, @ActionDelete, @ActionSecurityOnly, @ActionNoIndex, @ActionNotModified, @ActionSingleThreadedFD, @ActionError, @ActionRetry, @ActionOther, @LessThan15Min, @LessThan30Min, @LessThan1Hour, @LessThan4Hours, @LessThan1Day, @LessThan1Week, @LessThan1Month, @GreaterThan1Month, @ApplicationName, @ContentSourceName, @ThreadWaitingTime, @NumGetRequests, @NumPostRequests, @DiscoveryTime, @CTSTimeFromContentPipeline, @IndexerTimeFromContentPipeline, @LessThan2Min, @LessThan5Min, @LessThan10Min, @LessThan20Min, @LessThan45Min, @LessThan2Hours, @LessThan8Hours, @LessThan12Hours, @LessThan2Days, @LessThan3Days, @HybridParserTime, @SPOTime, 
			        @UTCDate'' AS NVARCHAR(MAX))
        SELECT @SQLParams = 
		        ''@PartitionId tinyint,
		        @LogTime datetime,
		        @MachineName nvarchar(128),
                @ApplicationId uniqueidentifier, @CrawlComponentId int, @CrawlId int, @ContentSourceId int, @NumDocuments bigint, @IsHighPriority int, @RepositoryTime bigint, @ProtocolHandlerTime bigint, @Filtering bigint, @CTSTime bigint, @SQLTime bigint, @GathererTime bigint, @TimeSpentInLinksTable bigint, @TimeSpentInQueue bigint, @ActionAddModify int, @ActionDelete int, @ActionSecurityOnly int, @ActionNoIndex int, @ActionNotModified int, @ActionSingleThreadedFD int, @ActionError int, @ActionRetry int, @ActionOther int, @LessThan15Min int, @LessThan30Min int, @LessThan1Hour int, @LessThan4Hours int, @LessThan1Day int, @LessThan1Week int, @LessThan1Month int, @GreaterThan1Month int, @ApplicationName nvarchar(1024), @ContentSourceName nvarchar(1024), @ThreadWaitingTime bigint, @NumGetRequests bigint, @NumPostRequests bigint, @DiscoveryTime bigint, @CTSTimeFromContentPipeline bigint, @IndexerTimeFromContentPipeline bigint, @LessThan2Min int, @LessThan5Min int, @LessThan10Min int, @LessThan20Min int, @LessThan45Min int, @LessThan2Hours int, @LessThan8Hours int, @LessThan12Hours int, @LessThan2Days int, @LessThan3Days int, @HybridParserTime bigint, @SPOTime bigint,         
		        @UTCDate datetime''
        exec sp_executesql
	        @SQL,
	        @SQLParams,
	        @PartitionId,
            @LogTime,
            @MachineName,
	        @ApplicationId, @CrawlComponentId, @CrawlId, @ContentSourceId, @NumDocuments, @IsHighPriority, @RepositoryTime, @ProtocolHandlerTime, @Filtering, @CTSTime, @SQLTime, @GathererTime, @TimeSpentInLinksTable, @TimeSpentInQueue, @ActionAddModify, @ActionDelete, @ActionSecurityOnly, @ActionNoIndex, @ActionNotModified, @ActionSingleThreadedFD, @ActionError, @ActionRetry, @ActionOther, @LessThan15Min, @LessThan30Min, @LessThan1Hour, @LessThan4Hours, @LessThan1Day, @LessThan1Week, @LessThan1Month, @GreaterThan1Month, @ApplicationName, @ContentSourceName, @ThreadWaitingTime, @NumGetRequests, @NumPostRequests, @DiscoveryTime, @CTSTimeFromContentPipeline, @IndexerTimeFromContentPipeline, @LessThan2Min, @LessThan5Min, @LessThan10Min, @LessThan20Min, @LessThan45Min, @LessThan2Hours, @LessThan8Hours, @LessThan12Hours, @LessThan2Days, @LessThan3Days, @HybridParserTime, @SPOTime, 
            @UTCDate
    END' 
END
GO
