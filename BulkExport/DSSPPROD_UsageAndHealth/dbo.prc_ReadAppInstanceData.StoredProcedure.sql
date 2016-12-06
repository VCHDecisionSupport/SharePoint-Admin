USE [DSSPPROD_UsageAndHealth]
GO
/****** Object:  StoredProcedure [dbo].[prc_ReadAppInstanceData]    Script Date: 11/10/2016 4:16:42 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[prc_ReadAppInstanceData]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[prc_ReadAppInstanceData]
    @AppInstanceId UniqueIdentifier = null,
    @EventId int = null,
    @BeginTime datetime = null, 
    @EndTime datetime = null, 
    @Rows int = 100
AS
BEGIN
    SET NOCOUNT ON
    IF (@AppInstanceId IS NULL)
    BEGIN
        RAISERROR(''Error. Valid appinstanceid needed'', 10, 1)
        RETURN
    END
    -- if eventid is null give results for all events
    SELECT TOP (@Rows) * FROM tvf_appusage_appinstanceId(@AppInstanceId, @BeginTime, @EndTime) 
    WHERE (EventId=@EventId or @EventId IS NULL) ORDER BY LogTime DESC
END
' 
END
GO
