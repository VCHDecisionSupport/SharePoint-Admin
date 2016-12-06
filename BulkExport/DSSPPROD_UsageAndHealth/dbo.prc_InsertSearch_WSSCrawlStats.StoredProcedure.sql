USE [DSSPPROD_UsageAndHealth]
GO
/****** Object:  StoredProcedure [dbo].[prc_InsertSearch_WSSCrawlStats]    Script Date: 11/10/2016 4:16:42 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[prc_InsertSearch_WSSCrawlStats]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[prc_InsertSearch_WSSCrawlStats]    
        @ContentDBHitCount Int, @ContentDBTimeSpent Int, @VirtualServerHitCount Int, @VirtualServerTimeSpent Int, @VirtualServerLocalCacheHitCount Int, @VirtualServerLocalCacheMissCount Int, @SiteCollectionHitCount Int, @SiteCollectionTimeSpent Int, @SiteCollectionLocalCacheHitCount Int, @SiteCollectionLocalCacheMissCount Int, @SiteCollectionGlobalCacheHitCount Int, @SiteCollectionGlobalCacheMissCount Int, @SiteHitCount Int, @SiteTimeSpent Int, @SiteLocalCacheHitCount Int, @SiteLocalCacheMissCount Int, @SiteGlobalCacheHitCount Int, @SiteGlobalCacheMissCount Int, @ListHitCount Int, @ListTimeSpent Int, @ListLocalCacheHitCount Int, @ListLocalCacheMissCount Int, @ListGlobalCacheHitCount Int, @ListGlobalCacheMissCount Int, @FolderHitCount Int, @FolderTimeSpent Int, @ListItemHitCount Int, @ListItemTimeSpent Int, @ListItemAttachmentsHitCount Int, @ListItemAttachmentsTimeSpent Int, @GetRequestsCount Int, @GetRequestsTimeSpent Int, @VirtualServerIISLatency Int, @VirtualServerSPRequestDuration Int, @ContentDBIISLatency Int, @ContentDBSPRequestDuration Int, @SiteCollectionIISLatency Int, @SiteCollectionSPRequestDuration Int, @SiteIISLatency Int, @SiteSPRequestDuration Int, @ListIISLatency Int, @ListSPRequestDuration Int, @FolderIISLatency Int, @FolderSPRequestDuration Int, @ListItemIISLatency Int, @ListItemSPRequestDuration Int, @ListItemAttachmentIISLatency Int, @ListItemAttachmentSPRequestDuration Int, @GetRequestIISLatency Int, @GetRequestSPRequestDuration Int,         
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
        SELECT @ConfigName = ''Retention Period - Search_WSSCrawlStats''
        SELECT @RetentionPeriod = CAST(dbo.fn_GetConfigValue(@ConfigName)  as smallint)
        IF (datediff(dd, @LogTime, @UTCDate) > @RetentionPeriod OR
            datediff(hh, @LogTime, @UTCDate) < 0)
        BEGIN
            RETURN
        END
	SELECT @ConfigName = ''Max Total Bytes - Search_WSSCrawlStats''
	SELECT @MaxBytes = CAST(dbo.fn_GetConfigValue(@ConfigName) as bigint) / @RetentionPeriod
        SELECT @PartitionId = dbo.fn_GetPartitionId(@LogTime)
        exec dbo.prc_LogAndRollOverPartition ''Search_WSSCrawlStats'', @UTCDate 
		-- Silently fail if the partition is full.
		IF (dbo.fn_GetPartitionSize(''Search_WSSCrawlStats_Partition'' + CAST(@PartitionId as NVARCHAR(MAX))) >= @MaxBytes)
		BEGIN
			RETURN
		END
        DECLARE @SQL nvarchar(MAX), 
		        @SQLParams nvarchar(MAX)
        SELECT @SQL =
	           CAST(''INSERT INTO [dbo].[Search_WSSCrawlStats_Partition'' AS NVARCHAR(MAX)) + CAST(@PartitionId as NVARCHAR(MAX)) + CAST('']
			        (PartitionId, 
			        LogTime,
			        MachineName,
                ContentDBHitCount, ContentDBTimeSpent, VirtualServerHitCount, VirtualServerTimeSpent, VirtualServerLocalCacheHitCount, VirtualServerLocalCacheMissCount, SiteCollectionHitCount, SiteCollectionTimeSpent, SiteCollectionLocalCacheHitCount, SiteCollectionLocalCacheMissCount, SiteCollectionGlobalCacheHitCount, SiteCollectionGlobalCacheMissCount, SiteHitCount, SiteTimeSpent, SiteLocalCacheHitCount, SiteLocalCacheMissCount, SiteGlobalCacheHitCount, SiteGlobalCacheMissCount, ListHitCount, ListTimeSpent, ListLocalCacheHitCount, ListLocalCacheMissCount, ListGlobalCacheHitCount, ListGlobalCacheMissCount, FolderHitCount, FolderTimeSpent, ListItemHitCount, ListItemTimeSpent, ListItemAttachmentsHitCount, ListItemAttachmentsTimeSpent, GetRequestsCount, GetRequestsTimeSpent, VirtualServerIISLatency, VirtualServerSPRequestDuration, ContentDBIISLatency, ContentDBSPRequestDuration, SiteCollectionIISLatency, SiteCollectionSPRequestDuration, SiteIISLatency, SiteSPRequestDuration, ListIISLatency, ListSPRequestDuration, FolderIISLatency, FolderSPRequestDuration, ListItemIISLatency, ListItemSPRequestDuration, ListItemAttachmentIISLatency, ListItemAttachmentSPRequestDuration, GetRequestIISLatency, GetRequestSPRequestDuration, 
			        RowCreatedTime) 
		        SELECT 
			        @PartitionId,
			        @LogTime,
			        @MachineName,
                @ContentDBHitCount, @ContentDBTimeSpent, @VirtualServerHitCount, @VirtualServerTimeSpent, @VirtualServerLocalCacheHitCount, @VirtualServerLocalCacheMissCount, @SiteCollectionHitCount, @SiteCollectionTimeSpent, @SiteCollectionLocalCacheHitCount, @SiteCollectionLocalCacheMissCount, @SiteCollectionGlobalCacheHitCount, @SiteCollectionGlobalCacheMissCount, @SiteHitCount, @SiteTimeSpent, @SiteLocalCacheHitCount, @SiteLocalCacheMissCount, @SiteGlobalCacheHitCount, @SiteGlobalCacheMissCount, @ListHitCount, @ListTimeSpent, @ListLocalCacheHitCount, @ListLocalCacheMissCount, @ListGlobalCacheHitCount, @ListGlobalCacheMissCount, @FolderHitCount, @FolderTimeSpent, @ListItemHitCount, @ListItemTimeSpent, @ListItemAttachmentsHitCount, @ListItemAttachmentsTimeSpent, @GetRequestsCount, @GetRequestsTimeSpent, @VirtualServerIISLatency, @VirtualServerSPRequestDuration, @ContentDBIISLatency, @ContentDBSPRequestDuration, @SiteCollectionIISLatency, @SiteCollectionSPRequestDuration, @SiteIISLatency, @SiteSPRequestDuration, @ListIISLatency, @ListSPRequestDuration, @FolderIISLatency, @FolderSPRequestDuration, @ListItemIISLatency, @ListItemSPRequestDuration, @ListItemAttachmentIISLatency, @ListItemAttachmentSPRequestDuration, @GetRequestIISLatency, @GetRequestSPRequestDuration, 
			        @UTCDate'' AS NVARCHAR(MAX))
        SELECT @SQLParams = 
		        ''@PartitionId tinyint,
		        @LogTime datetime,
		        @MachineName nvarchar(128),
                @ContentDBHitCount Int, @ContentDBTimeSpent Int, @VirtualServerHitCount Int, @VirtualServerTimeSpent Int, @VirtualServerLocalCacheHitCount Int, @VirtualServerLocalCacheMissCount Int, @SiteCollectionHitCount Int, @SiteCollectionTimeSpent Int, @SiteCollectionLocalCacheHitCount Int, @SiteCollectionLocalCacheMissCount Int, @SiteCollectionGlobalCacheHitCount Int, @SiteCollectionGlobalCacheMissCount Int, @SiteHitCount Int, @SiteTimeSpent Int, @SiteLocalCacheHitCount Int, @SiteLocalCacheMissCount Int, @SiteGlobalCacheHitCount Int, @SiteGlobalCacheMissCount Int, @ListHitCount Int, @ListTimeSpent Int, @ListLocalCacheHitCount Int, @ListLocalCacheMissCount Int, @ListGlobalCacheHitCount Int, @ListGlobalCacheMissCount Int, @FolderHitCount Int, @FolderTimeSpent Int, @ListItemHitCount Int, @ListItemTimeSpent Int, @ListItemAttachmentsHitCount Int, @ListItemAttachmentsTimeSpent Int, @GetRequestsCount Int, @GetRequestsTimeSpent Int, @VirtualServerIISLatency Int, @VirtualServerSPRequestDuration Int, @ContentDBIISLatency Int, @ContentDBSPRequestDuration Int, @SiteCollectionIISLatency Int, @SiteCollectionSPRequestDuration Int, @SiteIISLatency Int, @SiteSPRequestDuration Int, @ListIISLatency Int, @ListSPRequestDuration Int, @FolderIISLatency Int, @FolderSPRequestDuration Int, @ListItemIISLatency Int, @ListItemSPRequestDuration Int, @ListItemAttachmentIISLatency Int, @ListItemAttachmentSPRequestDuration Int, @GetRequestIISLatency Int, @GetRequestSPRequestDuration Int,         
		        @UTCDate datetime''
        exec sp_executesql
	        @SQL,
	        @SQLParams,
	        @PartitionId,
            @LogTime,
            @MachineName,
	        @ContentDBHitCount, @ContentDBTimeSpent, @VirtualServerHitCount, @VirtualServerTimeSpent, @VirtualServerLocalCacheHitCount, @VirtualServerLocalCacheMissCount, @SiteCollectionHitCount, @SiteCollectionTimeSpent, @SiteCollectionLocalCacheHitCount, @SiteCollectionLocalCacheMissCount, @SiteCollectionGlobalCacheHitCount, @SiteCollectionGlobalCacheMissCount, @SiteHitCount, @SiteTimeSpent, @SiteLocalCacheHitCount, @SiteLocalCacheMissCount, @SiteGlobalCacheHitCount, @SiteGlobalCacheMissCount, @ListHitCount, @ListTimeSpent, @ListLocalCacheHitCount, @ListLocalCacheMissCount, @ListGlobalCacheHitCount, @ListGlobalCacheMissCount, @FolderHitCount, @FolderTimeSpent, @ListItemHitCount, @ListItemTimeSpent, @ListItemAttachmentsHitCount, @ListItemAttachmentsTimeSpent, @GetRequestsCount, @GetRequestsTimeSpent, @VirtualServerIISLatency, @VirtualServerSPRequestDuration, @ContentDBIISLatency, @ContentDBSPRequestDuration, @SiteCollectionIISLatency, @SiteCollectionSPRequestDuration, @SiteIISLatency, @SiteSPRequestDuration, @ListIISLatency, @ListSPRequestDuration, @FolderIISLatency, @FolderSPRequestDuration, @ListItemIISLatency, @ListItemSPRequestDuration, @ListItemAttachmentIISLatency, @ListItemAttachmentSPRequestDuration, @GetRequestIISLatency, @GetRequestSPRequestDuration, 
            @UTCDate
    END' 
END
GO
