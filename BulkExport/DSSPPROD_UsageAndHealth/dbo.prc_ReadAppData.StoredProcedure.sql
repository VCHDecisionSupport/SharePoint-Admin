USE [DSSPPROD_UsageAndHealth]
GO
/****** Object:  StoredProcedure [dbo].[prc_ReadAppData]    Script Date: 11/10/2016 4:16:42 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[prc_ReadAppData]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[prc_ReadAppData]
    @SiteSubscriptionId UniqueIdentifier = null,
    @AppId UniqueIdentifier = null,
    @EventId int = null,
    @BeginTime datetime = null, 
    @EndTime datetime = null, 
    @Rows int = 100
AS
BEGIN
    SET NOCOUNT ON
    SELECT TOP (@Rows) * FROM tvf_appusage_appId(@AppId, @SiteSubscriptionId, @BeginTime, @EndTime) 
    WHERE (EventId=@EventId or @EventId IS NULL) ORDER BY LogTime DESC
END
' 
END
GO
