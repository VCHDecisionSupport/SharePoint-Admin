USE [DSSPPROD_UsageAndHealth]
GO
/****** Object:  StoredProcedure [dbo].[prc_TenantLog_CleanTVFs]    Script Date: 11/10/2016 4:16:42 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[prc_TenantLog_CleanTVFs]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[prc_TenantLog_CleanTVFs]
(
    @Debug bit = 0
)
AS
BEGIN
    EXEC dbo.prc_TenantLog_CreateTVFHelper ''SiteSubscriptionId'',
                                           @Debug
    EXEC dbo.prc_TenantLog_CreateTVFHelper ''Source'',
                                           @Debug
    EXEC dbo.prc_TenantLog_CreateTVFHelper ''CorrelationId'',
                                           @Debug
    EXEC dbo.prc_TenantLog_CreateTVFHelper ''UserLogin'',
                                           @Debug
END
' 
END
GO
