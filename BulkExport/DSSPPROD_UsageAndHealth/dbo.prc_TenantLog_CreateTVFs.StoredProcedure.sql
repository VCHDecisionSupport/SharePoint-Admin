USE [DSSPPROD_UsageAndHealth]
GO
/****** Object:  StoredProcedure [dbo].[prc_TenantLog_CreateTVFs]    Script Date: 11/10/2016 4:16:42 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[prc_TenantLog_CreateTVFs]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[prc_TenantLog_CreateTVFs]
(
    @Debug bit = 0
)
AS
BEGIN
    DECLARE @UserLoginTVFParams nvarchar(4000)
    EXEC dbo.prc_TenantLog_CreateTVFHelper ''SiteSubscriptionId'',
                                           '''',
                                           ''IX_TenantLog_SiteSubscriptionId'',
                                           '''',
                                           @Debug
    EXEC dbo.prc_TenantLog_CreateTVFHelper ''Source'',
                                           ''@Source int,'',
                                           ''IX_TenantLog_SiteSubscriptionId'',
                                           ''Source = @Source AND'',
                                           @Debug
    EXEC dbo.prc_TenantLog_CreateTVFHelper ''CorrelationId'',
                                           ''@CorrelationId uniqueidentifier,'',
                                           ''IX_TenantLog_CorrelationId'',
                                           ''CorrelationId = @CorrelationId AND'',
                                           @Debug
    SET @UserLoginTVFParams = ''@UserLogin nvarchar('' + CAST(300 as nvarchar) +''),''
    EXEC dbo.prc_TenantLog_CreateTVFHelper ''UserLogin'',
                                           @UserLoginTVFParams,
                                           ''IX_TenantLog_UserLogin'',
                                          N''UserLogin = @UserLogin AND'',
                                           @Debug
END
' 
END
GO
