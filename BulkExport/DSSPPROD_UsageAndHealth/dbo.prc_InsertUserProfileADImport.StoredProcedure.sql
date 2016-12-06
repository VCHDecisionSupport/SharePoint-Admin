USE [DSSPPROD_UsageAndHealth]
GO
/****** Object:  StoredProcedure [dbo].[prc_InsertUserProfileADImport]    Script Date: 11/10/2016 4:16:42 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[prc_InsertUserProfileADImport]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[prc_InsertUserProfileADImport]    
        @FarmId UniqueIdentifier, @SiteSubscriptionId UniqueIdentifier, @UserLogin NVarChar(300), @CorrelationId UniqueIdentifier, @ImportStartTime DateTime, @DcName NVarChar(128), @ImportEndTime DateTime, @ImportSuccessCount BigInt, @ImportFailureCount BigInt, @ImportIgnoredCount BigInt, @ImportTimeSpentInDirectory BigInt, @ImportTimeSpentInProfile BigInt, @ImportTimeSpentInDefrag BigInt, @ImportDefragCount BigInt, @ImportMaxDefragTime BigInt, @RetrySuccessCount BigInt, @RetryFailureCount BigInt, @RetryIgnoredCount BigInt, @RetryTimeSpentInDirectory BigInt, @RetryTimeSpentInProfile BigInt, @Message1 NVarChar(3800), @Message2 NVarChar(3800), @Message3 NVarChar(3800), @Message4 NVarChar(3800), @Message5 NVarChar(3800), @Message6 NVarChar(3800), @Message7 NVarChar(3800), @Message8 NVarChar(3800), @NumTenants BigInt, @NumOUs BigInt, @ExportAdds BigInt, @ExportDeletes BigInt, @ExportUpdates BigInt, @TotalUsersInDB BigInt, @TotalGroupsInDB BigInt, @TerminationCode TinyInt, @TotalUsersImported BigInt, @TotalGroupsImported BigInt,         
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
        SELECT @ConfigName = ''Retention Period - UserProfileADImport''
        SELECT @RetentionPeriod = CAST(dbo.fn_GetConfigValue(@ConfigName)  as smallint)
        IF (datediff(dd, @LogTime, @UTCDate) > @RetentionPeriod OR
            datediff(hh, @LogTime, @UTCDate) < 0)
        BEGIN
            RETURN
        END
	SELECT @ConfigName = ''Max Total Bytes - UserProfileADImport''
	SELECT @MaxBytes = CAST(dbo.fn_GetConfigValue(@ConfigName) as bigint) / @RetentionPeriod
        SELECT @PartitionId = dbo.fn_GetPartitionId(@LogTime)
        exec dbo.prc_LogAndRollOverPartition ''UserProfileADImport'', @UTCDate 
		-- Silently fail if the partition is full.
		IF (dbo.fn_GetPartitionSize(''UserProfileADImport_Partition'' + CAST(@PartitionId as NVARCHAR(MAX))) >= @MaxBytes)
		BEGIN
			RETURN
		END
        DECLARE @SQL nvarchar(MAX), 
		        @SQLParams nvarchar(MAX)
        SELECT @SQL =
	           CAST(''INSERT INTO [dbo].[UserProfileADImport_Partition'' AS NVARCHAR(MAX)) + CAST(@PartitionId as NVARCHAR(MAX)) + CAST('']
			        (PartitionId, 
			        LogTime,
			        MachineName,
                FarmId, SiteSubscriptionId, UserLogin, CorrelationId, ImportStartTime, DcName, ImportEndTime, ImportSuccessCount, ImportFailureCount, ImportIgnoredCount, ImportTimeSpentInDirectory, ImportTimeSpentInProfile, ImportTimeSpentInDefrag, ImportDefragCount, ImportMaxDefragTime, RetrySuccessCount, RetryFailureCount, RetryIgnoredCount, RetryTimeSpentInDirectory, RetryTimeSpentInProfile, Message1, Message2, Message3, Message4, Message5, Message6, Message7, Message8, NumTenants, NumOUs, ExportAdds, ExportDeletes, ExportUpdates, TotalUsersInDB, TotalGroupsInDB, TerminationCode, TotalUsersImported, TotalGroupsImported, 
			        RowCreatedTime) 
		        SELECT 
			        @PartitionId,
			        @LogTime,
			        @MachineName,
                @FarmId, @SiteSubscriptionId, @UserLogin, @CorrelationId, @ImportStartTime, @DcName, @ImportEndTime, @ImportSuccessCount, @ImportFailureCount, @ImportIgnoredCount, @ImportTimeSpentInDirectory, @ImportTimeSpentInProfile, @ImportTimeSpentInDefrag, @ImportDefragCount, @ImportMaxDefragTime, @RetrySuccessCount, @RetryFailureCount, @RetryIgnoredCount, @RetryTimeSpentInDirectory, @RetryTimeSpentInProfile, @Message1, @Message2, @Message3, @Message4, @Message5, @Message6, @Message7, @Message8, @NumTenants, @NumOUs, @ExportAdds, @ExportDeletes, @ExportUpdates, @TotalUsersInDB, @TotalGroupsInDB, @TerminationCode, @TotalUsersImported, @TotalGroupsImported, 
			        @UTCDate'' AS NVARCHAR(MAX))
        SELECT @SQLParams = 
		        ''@PartitionId tinyint,
		        @LogTime datetime,
		        @MachineName nvarchar(128),
                @FarmId UniqueIdentifier, @SiteSubscriptionId UniqueIdentifier, @UserLogin NVarChar(300), @CorrelationId UniqueIdentifier, @ImportStartTime DateTime, @DcName NVarChar(128), @ImportEndTime DateTime, @ImportSuccessCount BigInt, @ImportFailureCount BigInt, @ImportIgnoredCount BigInt, @ImportTimeSpentInDirectory BigInt, @ImportTimeSpentInProfile BigInt, @ImportTimeSpentInDefrag BigInt, @ImportDefragCount BigInt, @ImportMaxDefragTime BigInt, @RetrySuccessCount BigInt, @RetryFailureCount BigInt, @RetryIgnoredCount BigInt, @RetryTimeSpentInDirectory BigInt, @RetryTimeSpentInProfile BigInt, @Message1 NVarChar(3800), @Message2 NVarChar(3800), @Message3 NVarChar(3800), @Message4 NVarChar(3800), @Message5 NVarChar(3800), @Message6 NVarChar(3800), @Message7 NVarChar(3800), @Message8 NVarChar(3800), @NumTenants BigInt, @NumOUs BigInt, @ExportAdds BigInt, @ExportDeletes BigInt, @ExportUpdates BigInt, @TotalUsersInDB BigInt, @TotalGroupsInDB BigInt, @TerminationCode TinyInt, @TotalUsersImported BigInt, @TotalGroupsImported BigInt,         
		        @UTCDate datetime''
        exec sp_executesql
	        @SQL,
	        @SQLParams,
	        @PartitionId,
            @LogTime,
            @MachineName,
	        @FarmId, @SiteSubscriptionId, @UserLogin, @CorrelationId, @ImportStartTime, @DcName, @ImportEndTime, @ImportSuccessCount, @ImportFailureCount, @ImportIgnoredCount, @ImportTimeSpentInDirectory, @ImportTimeSpentInProfile, @ImportTimeSpentInDefrag, @ImportDefragCount, @ImportMaxDefragTime, @RetrySuccessCount, @RetryFailureCount, @RetryIgnoredCount, @RetryTimeSpentInDirectory, @RetryTimeSpentInProfile, @Message1, @Message2, @Message3, @Message4, @Message5, @Message6, @Message7, @Message8, @NumTenants, @NumOUs, @ExportAdds, @ExportDeletes, @ExportUpdates, @TotalUsersInDB, @TotalGroupsInDB, @TerminationCode, @TotalUsersImported, @TotalGroupsImported, 
            @UTCDate
    END' 
END
GO
