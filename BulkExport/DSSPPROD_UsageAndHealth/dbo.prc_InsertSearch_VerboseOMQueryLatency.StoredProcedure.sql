USE [DSSPPROD_UsageAndHealth]
GO
/****** Object:  StoredProcedure [dbo].[prc_InsertSearch_VerboseOMQueryLatency]    Script Date: 11/10/2016 4:16:42 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[prc_InsertSearch_VerboseOMQueryLatency]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[prc_InsertSearch_VerboseOMQueryLatency]    
        @ApplicationId UniqueIdentifier, @CorrelationId UniqueIdentifier, @TotalQueryTimeMs Int, @IMSProxyTimeMs Int, @QPTimeMs Int, @QueryTerms NVarChar(4000), @QPMachine NVarChar(500), @NumHitsRequested Int,         
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
        SELECT @ConfigName = ''Retention Period - Search_VerboseOMQueryLatency''
        SELECT @RetentionPeriod = CAST(dbo.fn_GetConfigValue(@ConfigName)  as smallint)
        IF (datediff(dd, @LogTime, @UTCDate) > @RetentionPeriod OR
            datediff(hh, @LogTime, @UTCDate) < 0)
        BEGIN
            RETURN
        END
	SELECT @ConfigName = ''Max Total Bytes - Search_VerboseOMQueryLatency''
	SELECT @MaxBytes = CAST(dbo.fn_GetConfigValue(@ConfigName) as bigint) / @RetentionPeriod
        SELECT @PartitionId = dbo.fn_GetPartitionId(@LogTime)
        exec dbo.prc_LogAndRollOverPartition ''Search_VerboseOMQueryLatency'', @UTCDate 
		-- Silently fail if the partition is full.
		IF (dbo.fn_GetPartitionSize(''Search_VerboseOMQueryLatency_Partition'' + CAST(@PartitionId as NVARCHAR(MAX))) >= @MaxBytes)
		BEGIN
			RETURN
		END
        DECLARE @SQL nvarchar(MAX), 
		        @SQLParams nvarchar(MAX)
        SELECT @SQL =
	           CAST(''INSERT INTO [dbo].[Search_VerboseOMQueryLatency_Partition'' AS NVARCHAR(MAX)) + CAST(@PartitionId as NVARCHAR(MAX)) + CAST('']
			        (PartitionId, 
			        LogTime,
			        MachineName,
                ApplicationId, CorrelationId, TotalQueryTimeMs, IMSProxyTimeMs, QPTimeMs, QueryTerms, QPMachine, NumHitsRequested, 
			        RowCreatedTime) 
		        SELECT 
			        @PartitionId,
			        @LogTime,
			        @MachineName,
                @ApplicationId, @CorrelationId, @TotalQueryTimeMs, @IMSProxyTimeMs, @QPTimeMs, @QueryTerms, @QPMachine, @NumHitsRequested, 
			        @UTCDate'' AS NVARCHAR(MAX))
        SELECT @SQLParams = 
		        ''@PartitionId tinyint,
		        @LogTime datetime,
		        @MachineName nvarchar(128),
                @ApplicationId UniqueIdentifier, @CorrelationId UniqueIdentifier, @TotalQueryTimeMs Int, @IMSProxyTimeMs Int, @QPTimeMs Int, @QueryTerms NVarChar(4000), @QPMachine NVarChar(500), @NumHitsRequested Int,         
		        @UTCDate datetime''
        exec sp_executesql
	        @SQL,
	        @SQLParams,
	        @PartitionId,
            @LogTime,
            @MachineName,
	        @ApplicationId, @CorrelationId, @TotalQueryTimeMs, @IMSProxyTimeMs, @QPTimeMs, @QueryTerms, @QPMachine, @NumHitsRequested, 
            @UTCDate
    END' 
END
GO
