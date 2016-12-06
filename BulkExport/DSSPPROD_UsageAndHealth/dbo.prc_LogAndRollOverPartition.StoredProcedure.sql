USE [DSSPPROD_UsageAndHealth]
GO
/****** Object:  StoredProcedure [dbo].[prc_LogAndRollOverPartition]    Script Date: 11/10/2016 4:16:42 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[prc_LogAndRollOverPartition]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[prc_LogAndRollOverPartition]
(
    @TypeName nvarchar(100),
    @UTCDate datetime = NULL,
    @Debug bit = 0
)
AS
BEGIN
    SET NOCOUNT ON
    DECLARE @CurrentPartitionId tinyint,
            @NextPartitionId tinyint,
	    @LastPartitionId tinyint,
            @TableName sysname,
            @SQL nvarchar(4000),
            @ConfigName nvarchar(255),
            @Retention tinyint,
	    @Partition smallint
    IF (@UTCDate IS NULL)
        SELECT @UTCDate = getutcdate()
    SELECT @ConfigName = ''Retention Period - '' + @TypeName
    SELECT @Retention = dbo.fn_GetConfigValue(@ConfigName)
    SELECT @ConfigName = ''Max Partition ID - '' + @TypeName
    SELECT @CurrentPartitionId = dbo.fn_GetConfigValue(@ConfigName) -- the max stored partition ID
    SELECT @NextPartitionId = dbo.fn_GetPartitionIdByType(@TypeName, @UTCDate)
    SELECT @Partition = (@Retention+1) * -1;
    SELECT @LastPartitionId = dbo.fn_GetPartitionIdByType(@TypeName, dateadd(day, @Partition, @UTCDate))
    IF (@NextPartitionId <> @CurrentPartitionId)
    BEGIN
        SELECT @TableName = @TypeName + ''_Partition'' + CAST(@NextPartitionId as nvarchar)
        SELECT @SQL = ''IF EXISTS (SELECT TOP 1 1 FROM '' + ''[dbo].['' + @TableName + '']'' + '' WHERE datediff(day, LogTime, getutcdate()) >= '' 
            + CAST(@Retention as varchar) + '') '' +
            ''TRUNCATE TABLE '' + ''[dbo].['' + @TableName + '']''
        IF (@Debug=1)
            SELECT @SQL
        ELSE
        BEGIN
            exec sp_executesql @SQL
            EXEC prc_SetConfigValue @ConfigName, @NextPartitionId 
        END
	IF (@Retention < 31)
	BEGIN
   	    -- Clean the previous partition
            SELECT @TableName = @TypeName + ''_Partition'' + CAST(@LastPartitionId as nvarchar)
            SELECT @SQL = ''IF EXISTS (SELECT TOP 1 1 FROM '' + ''[dbo].['' + @TableName + '']'' + '' WHERE datediff(day, LogTime, getutcdate()) >= '' 
                + CAST(@Retention as varchar) + '') '' +
               ''TRUNCATE TABLE '' + ''[dbo].['' + @TableName + '']''
            IF (@Debug=1)
                SELECT @SQL
            ELSE
            BEGIN
                exec sp_executesql @SQL
            END
	END
    END    
END
' 
END
GO
