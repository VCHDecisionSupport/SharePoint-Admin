USE [DSSPPROD_UsageAndHealth]
GO
/****** Object:  StoredProcedure [dbo].[prc_TenantLog_CreateTVFHelper]    Script Date: 11/10/2016 4:16:42 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[prc_TenantLog_CreateTVFHelper]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[prc_TenantLog_CreateTVFHelper]
(
    @QueryName nvarchar(4000),
    @InputParameters nvarchar(4000),
    @IndexName sysname,
    @Filter nvarchar(4000),
    @Debug bit = 0 
)
AS
BEGIN
    DECLARE @SQL nvarchar(max),
            @Counter tinyint,
            @MaxPartitions tinyint
        BEGIN TRY
        --Clear the TVF first if it exists
        exec dbo.prc_TenantLog_CleanTVFHelper @QueryName,@Debug
        SET @InputParameters = @InputParameters + '' @SiteSubscriptionId uniqueidentifier, @BeginDateTimeUtc datetime, @EndDateTimeUtc datetime, @NRows int''
        SET @MaxPartitions = 31 + 1
        SET @Counter = 0
        SET @SQL=''CREATE FUNCTION [dbo].[TVF_TenantLog_'' + @QueryName + ''](''+ @InputParameters +
         '') RETURNS TABLE AS RETURN WITH CTEALL AS (''
        WHILE (@Counter < @MaxPartitions)
        BEGIN
            IF (@Counter > 0)
                SET @SQL = @SQL + '' UNION ALL ''
            SELECT @SQL = @SQL + 
                '' SELECT TOP (@NRows) * FROM '' + 
                ''[dbo].['' + ''TenantLog'' + ''_Partition'' + cast(@Counter as nvarchar) + '']''+
                '' WITH(NOLOCK, INDEX=''+
                @IndexName+'') WHERE ''+@Filter+'' SitesubscriptionId = @SiteSubscriptionId AND (LogTime BETWEEN @BeginDatetimeUtc AND @EndDateTimeUtc)'' +
                +'' ORDER BY LogTime DESC''
            SET @Counter = @Counter+1
        END
        SET @SQL=@SQL+'') SELECT TOP (@NRows) * FROM CTEALL ORDER BY LogTime DESC''
        IF (@Debug = 1)
            PRINT @SQL
        ELSE
            exec sp_executesql @SQL
        END TRY
        BEGIN CATCH
            SELECT @SQL = ''Errors occurred '' + ERROR_MESSAGE()
            RAISERROR(@SQL, 10, 1)
        END CATCH
END
' 
END
GO
