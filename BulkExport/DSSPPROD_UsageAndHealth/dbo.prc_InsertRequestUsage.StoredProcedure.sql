USE [DSSPPROD_UsageAndHealth]
GO
/****** Object:  StoredProcedure [dbo].[prc_InsertRequestUsage]    Script Date: 11/10/2016 4:16:42 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[prc_InsertRequestUsage]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[prc_InsertRequestUsage]    
        @FarmId uniqueidentifier, @SiteSubscriptionId uniqueidentifier, @UserLogin nvarchar(300), @CorrelationId uniqueidentifier, @WebApplicationId uniqueidentifier, @ServerUrl nvarchar(256), @SiteId uniqueidentifier, @SiteUrl nvarchar(256), @WebId uniqueidentifier, @WebUrl nvarchar(256), @DocumentPath nvarchar(256), @ContentTypeId nvarchar(1024), @QueryString nvarchar(512), @BytesConsumed int, @HttpStatus smallint, @SessionId nvarchar(64), @ReferrerUrl nvarchar(260), @ReferrerQueryString nvarchar(512), @Browser nvarchar(128), @UserAgent nvarchar(512), @UserAddress nvarchar(46), @RequestCount smallint, @QueryCount smallint, @QueryDurationSum bigint, @ServiceCallCount smallint, @ServiceCallDurationSum bigint, @OperationCount bigint, @Duration bigint, @RequestType nvarchar(16), @Title nvarchar(128), @SqlLogicalReads bigint, @CPUMCycles bigint, @CPUDuration bigint, @DistributedCacheReads bigint, @DistributedCacheReadsDuration bigint, @DistributedCacheReadsSize bigint, @DistributedCacheWrites bigint, @DistributedCacheWritesDuration bigint, @DistributedCacheWritesSize bigint, @DistributedCacheMisses bigint, @DistributedCacheHits bigint, @DistributedCacheFailures bigint, @DistributedCachedObjectsRequested bigint, @ManagedMemoryBytes bigint, @ManagedMemoryBytesLOH bigint, @IisLatency bigint, @RequestManagementRoutedServerUrl nvarchar(256), @RequestManagementThrottled bit, @RequestManagementUploadDuration bigint, @RequestManagementResponseDuration bigint, @RequestManagementDownloadDuration bigint, @HeadersForwarded nvarchar(256), @ClaimsAuthenticationTime bigint, @ClaimsAuthenticationTimeType nvarchar(60), @MUIEnabled bit, @WebCulture int, @UICulture int, @LargeGapStartTag nvarchar(16), @LargeGapEndTag nvarchar(16), @LargeGapTime bigint, @DocumentPathOriginalCasing nvarchar(256),         
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
        SELECT @ConfigName = ''Retention Period - RequestUsage''
        SELECT @RetentionPeriod = CAST(dbo.fn_GetConfigValue(@ConfigName)  as smallint)
        IF (datediff(dd, @LogTime, @UTCDate) > @RetentionPeriod OR
            datediff(hh, @LogTime, @UTCDate) < 0)
        BEGIN
            RETURN
        END
	SELECT @ConfigName = ''Max Total Bytes - RequestUsage''
	SELECT @MaxBytes = CAST(dbo.fn_GetConfigValue(@ConfigName) as bigint) / @RetentionPeriod
        SELECT @PartitionId = dbo.fn_GetPartitionId(@LogTime)
        exec dbo.prc_LogAndRollOverPartition ''RequestUsage'', @UTCDate 
		-- Silently fail if the partition is full.
		IF (dbo.fn_GetPartitionSize(''RequestUsage_Partition'' + CAST(@PartitionId as NVARCHAR(MAX))) >= @MaxBytes)
		BEGIN
			RETURN
		END
        DECLARE @SQL nvarchar(MAX), 
		        @SQLParams nvarchar(MAX)
        SELECT @SQL =
	           CAST(''INSERT INTO [dbo].[RequestUsage_Partition'' AS NVARCHAR(MAX)) + CAST(@PartitionId as NVARCHAR(MAX)) + CAST('']
			        (PartitionId, 
			        LogTime,
			        MachineName,
                FarmId, SiteSubscriptionId, UserLogin, CorrelationId, WebApplicationId, ServerUrl, SiteId, SiteUrl, WebId, WebUrl, DocumentPath, ContentTypeId, QueryString, BytesConsumed, HttpStatus, SessionId, ReferrerUrl, ReferrerQueryString, Browser, UserAgent, UserAddress, RequestCount, QueryCount, QueryDurationSum, ServiceCallCount, ServiceCallDurationSum, OperationCount, Duration, RequestType, Title, SqlLogicalReads, CPUMCycles, CPUDuration, DistributedCacheReads, DistributedCacheReadsDuration, DistributedCacheReadsSize, DistributedCacheWrites, DistributedCacheWritesDuration, DistributedCacheWritesSize, DistributedCacheMisses, DistributedCacheHits, DistributedCacheFailures, DistributedCachedObjectsRequested, ManagedMemoryBytes, ManagedMemoryBytesLOH, IisLatency, RequestManagementRoutedServerUrl, RequestManagementThrottled, RequestManagementUploadDuration, RequestManagementResponseDuration, RequestManagementDownloadDuration, HeadersForwarded, ClaimsAuthenticationTime, ClaimsAuthenticationTimeType, MUIEnabled, WebCulture, UICulture, LargeGapStartTag, LargeGapEndTag, LargeGapTime, DocumentPathOriginalCasing, 
			        RowCreatedTime) 
		        SELECT 
			        @PartitionId,
			        @LogTime,
			        @MachineName,
                @FarmId, @SiteSubscriptionId, @UserLogin, @CorrelationId, @WebApplicationId, @ServerUrl, @SiteId, @SiteUrl, @WebId, @WebUrl, @DocumentPath, @ContentTypeId, @QueryString, @BytesConsumed, @HttpStatus, @SessionId, @ReferrerUrl, @ReferrerQueryString, @Browser, @UserAgent, @UserAddress, @RequestCount, @QueryCount, @QueryDurationSum, @ServiceCallCount, @ServiceCallDurationSum, @OperationCount, @Duration, @RequestType, @Title, @SqlLogicalReads, @CPUMCycles, @CPUDuration, @DistributedCacheReads, @DistributedCacheReadsDuration, @DistributedCacheReadsSize, @DistributedCacheWrites, @DistributedCacheWritesDuration, @DistributedCacheWritesSize, @DistributedCacheMisses, @DistributedCacheHits, @DistributedCacheFailures, @DistributedCachedObjectsRequested, @ManagedMemoryBytes, @ManagedMemoryBytesLOH, @IisLatency, @RequestManagementRoutedServerUrl, @RequestManagementThrottled, @RequestManagementUploadDuration, @RequestManagementResponseDuration, @RequestManagementDownloadDuration, @HeadersForwarded, @ClaimsAuthenticationTime, @ClaimsAuthenticationTimeType, @MUIEnabled, @WebCulture, @UICulture, @LargeGapStartTag, @LargeGapEndTag, @LargeGapTime, @DocumentPathOriginalCasing, 
			        @UTCDate'' AS NVARCHAR(MAX))
        SELECT @SQLParams = 
		        ''@PartitionId tinyint,
		        @LogTime datetime,
		        @MachineName nvarchar(128),
                @FarmId uniqueidentifier, @SiteSubscriptionId uniqueidentifier, @UserLogin nvarchar(300), @CorrelationId uniqueidentifier, @WebApplicationId uniqueidentifier, @ServerUrl nvarchar(256), @SiteId uniqueidentifier, @SiteUrl nvarchar(256), @WebId uniqueidentifier, @WebUrl nvarchar(256), @DocumentPath nvarchar(256), @ContentTypeId nvarchar(1024), @QueryString nvarchar(512), @BytesConsumed int, @HttpStatus smallint, @SessionId nvarchar(64), @ReferrerUrl nvarchar(260), @ReferrerQueryString nvarchar(512), @Browser nvarchar(128), @UserAgent nvarchar(512), @UserAddress nvarchar(46), @RequestCount smallint, @QueryCount smallint, @QueryDurationSum bigint, @ServiceCallCount smallint, @ServiceCallDurationSum bigint, @OperationCount bigint, @Duration bigint, @RequestType nvarchar(16), @Title nvarchar(128), @SqlLogicalReads bigint, @CPUMCycles bigint, @CPUDuration bigint, @DistributedCacheReads bigint, @DistributedCacheReadsDuration bigint, @DistributedCacheReadsSize bigint, @DistributedCacheWrites bigint, @DistributedCacheWritesDuration bigint, @DistributedCacheWritesSize bigint, @DistributedCacheMisses bigint, @DistributedCacheHits bigint, @DistributedCacheFailures bigint, @DistributedCachedObjectsRequested bigint, @ManagedMemoryBytes bigint, @ManagedMemoryBytesLOH bigint, @IisLatency bigint, @RequestManagementRoutedServerUrl nvarchar(256), @RequestManagementThrottled bit, @RequestManagementUploadDuration bigint, @RequestManagementResponseDuration bigint, @RequestManagementDownloadDuration bigint, @HeadersForwarded nvarchar(256), @ClaimsAuthenticationTime bigint, @ClaimsAuthenticationTimeType nvarchar(60), @MUIEnabled bit, @WebCulture int, @UICulture int, @LargeGapStartTag nvarchar(16), @LargeGapEndTag nvarchar(16), @LargeGapTime bigint, @DocumentPathOriginalCasing nvarchar(256),         
		        @UTCDate datetime''
        exec sp_executesql
	        @SQL,
	        @SQLParams,
	        @PartitionId,
            @LogTime,
            @MachineName,
	        @FarmId, @SiteSubscriptionId, @UserLogin, @CorrelationId, @WebApplicationId, @ServerUrl, @SiteId, @SiteUrl, @WebId, @WebUrl, @DocumentPath, @ContentTypeId, @QueryString, @BytesConsumed, @HttpStatus, @SessionId, @ReferrerUrl, @ReferrerQueryString, @Browser, @UserAgent, @UserAddress, @RequestCount, @QueryCount, @QueryDurationSum, @ServiceCallCount, @ServiceCallDurationSum, @OperationCount, @Duration, @RequestType, @Title, @SqlLogicalReads, @CPUMCycles, @CPUDuration, @DistributedCacheReads, @DistributedCacheReadsDuration, @DistributedCacheReadsSize, @DistributedCacheWrites, @DistributedCacheWritesDuration, @DistributedCacheWritesSize, @DistributedCacheMisses, @DistributedCacheHits, @DistributedCacheFailures, @DistributedCachedObjectsRequested, @ManagedMemoryBytes, @ManagedMemoryBytesLOH, @IisLatency, @RequestManagementRoutedServerUrl, @RequestManagementThrottled, @RequestManagementUploadDuration, @RequestManagementResponseDuration, @RequestManagementDownloadDuration, @HeadersForwarded, @ClaimsAuthenticationTime, @ClaimsAuthenticationTimeType, @MUIEnabled, @WebCulture, @UICulture, @LargeGapStartTag, @LargeGapEndTag, @LargeGapTime, @DocumentPathOriginalCasing, 
            @UTCDate
    END' 
END
GO
