USE [DSSPPROD_UsageAndHealth]
GO
/****** Object:  StoredProcedure [dbo].[proc_AlterRetentionForType]    Script Date: 11/10/2016 4:16:42 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[proc_AlterRetentionForType]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[proc_AlterRetentionForType]
(
    @TypeName nvarchar(100),
    @RetentionPeriod tinyint = 31,
    @Debug bit = 0
)
AS
BEGIN
    SET NOCOUNT ON
    DECLARE @ConfigName nvarchar(255),
            @CurrentRetention tinyint,
	    @SQL nvarchar(4000)
    -- Ensure new retention period is within allowed values
    IF ((@RetentionPeriod IS NULL) OR (@RetentionPeriod < 0) OR (@RetentionPeriod > 31))
    BEGIN
        SELECT @RetentionPeriod = 31
    END
    -- Get old retention period
    SELECT @ConfigName = ''Retention Period - '' + @TypeName
    SELECT @CurrentRetention = dbo.fn_GetConfigValue(@ConfigName) 
    -- Return if no change
    IF(@RetentionPeriod = @CurrentRetention)
    BEGIN
        RETURN
    END
    IF (@Debug = 0)	
	exec prc_SetConfigValue @ConfigName, @RetentionPeriod
    -- Update configuration value
    IF (ISNULL(@CurrentRetention, @RetentionPeriod) > @RetentionPeriod)
    BEGIN
	SELECT @SQL = dbo.fn_TruncateUnusedPartitionsHelper (@TypeName, @CurrentRetention, @RetentionPeriod)
	IF (@Debug = 1)
            PRINT @SQL
        ELSE
            exec sp_executesql @SQL               
    END  
END
' 
END
GO
