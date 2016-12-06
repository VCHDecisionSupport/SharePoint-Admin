USE [DSSPPROD_UsageAndHealth]
GO
/****** Object:  StoredProcedure [dbo].[prc_GetLastUTCDate]    Script Date: 11/10/2016 4:16:42 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[prc_GetLastUTCDate]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[prc_GetLastUTCDate]
    @TypeName nvarchar(100),
    @MachineName nvarchar(128),
    @MinUTCDate datetime = NULL,
    @Debug bit = 0
AS
BEGIN
	SET NOCOUNT ON
	DECLARE @ReturnValue datetime,
			@SQL nvarchar(max),
			@MaxPartitionID int,
			@ConfigName nvarchar(255),
			@MaxBytes bigint,
			@CurrentPartitionSize bigint,
			@CurrentPartitionID int,
			@CurrentPartitionName nvarchar(255),
			@Retention int,
			@SqlVersion nvarchar(255)
	DECLARE @Results TABLE (LogTime datetime)
	SELECT @ConfigName = ''Max Partition ID - '' + @TypeName
	SELECT @MaxPartitionID = CAST(dbo.fn_GetConfigValue(@ConfigName) as int) * -1
	SELECT @ConfigName = ''Max Total Bytes - '' + @TypeName
	SELECT @MaxBytes = CAST(dbo.fn_GetConfigValue(@ConfigName) as bigint) 
	IF (@MaxBytes is null)
		SELECT @MaxBytes = dbo.fn_GetDefaultMaxBytesPerPartition()
	SELECT @ConfigName = ''Retention Period - '' + @TypeName
	SELECT @Retention = CAST(dbo.fn_GetConfigValue(@ConfigName) as bigint) 
	IF (@Retention is null)
		SELECT @Retention = 31
	SELECT @MaxBytes = @MaxBytes / @Retention 
	SELECT @Retention = @Retention * -1
	IF (@MinUTCDate IS NULL)
		SELECT @MinUTCDate = dateadd(day, @Retention, getutcdate())
	-- Get the natural largest UTC time for this machine
	select @SQL= ''select max(LogTime) from dbo.'' + @TypeName + '' (NOLOCK) where LogTime >= @MinUTCDate and MachineName = @MachineName''
	IF (@Debug = 1)
		PRINT @SQL
	INSERT INTO @Results exec sp_executesql @SQL, N''@MinUTCDate datetime, @MachineName nvarchar(255)'', @MinUTCDate, @MachineName
	SELECT @ReturnValue = LogTime from @Results
	IF (@Debug = 1)
		SELECT @ReturnValue OriginalReturnValue
	-- Fall back to the default if null
	IF (@ReturnValue is null)
		SET @ReturnValue = @MinUTCDate
	-- Ensure that the partition is not full
	SELECT @CurrentPartitionID = dbo.fn_GetPartitionId(@ReturnValue)
	SELECT @CurrentPartitionName = @TypeName + ''_Partition'' + CAST(@CurrentPartitionID as nvarchar)
	IF (dbo.fn_GetPartitionSize(@CurrentPartitionName) >= @MaxBytes )
	BEGIN	
		SELECT @ReturnValue = CONVERT(datetime, CONVERT(varchar(8), @ReturnValue, 1) + '' 00:00'')
		IF (@Debug = 1)
			SELECT @ReturnValue ModifiedReturnValue
		WHILE(dbo.fn_GetPartitionSize(@CurrentPartitionName) >= @MaxBytes )
		BEGIN
			-- Issue: future partitions should be 0 bytes
			-- Issue: this can roll over.  We need to use a function to get the next partitionID
			SELECT @ReturnValue = dateadd(day, 1, @ReturnValue)
			IF (@Debug = 1)
				SELECT @ReturnValue ModifiedReturnValue
			IF (@ReturnValue > getutcdate())
			BEGIN
				BREAK;
			END		
			SELECT @CurrentPartitionID = dbo.fn_GetPartitionId(@ReturnValue)
			SELECT @CurrentPartitionName = @TypeName + ''_Partition'' + CAST(@CurrentPartitionID as nvarchar)
		END
	END
	select @ReturnValue UTCDate
END
' 
END
GO
