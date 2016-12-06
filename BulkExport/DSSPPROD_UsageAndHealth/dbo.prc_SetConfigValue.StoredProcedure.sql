USE [DSSPPROD_UsageAndHealth]
GO
/****** Object:  StoredProcedure [dbo].[prc_SetConfigValue]    Script Date: 11/10/2016 4:16:42 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[prc_SetConfigValue]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[prc_SetConfigValue] 
(
    @ConfigName nvarchar(255), 
    @ConfigValue nvarchar(255)
)
AS
BEGIN
    SET NOCOUNT ON
	BEGIN TRAN
    UPDATE dbo.Configuration SET ConfigValue = @ConfigValue WHERE ConfigName = @ConfigName
	IF (@@ROWCOUNT = 0)
		INSERT dbo.Configuration (ConfigName, ConfigValue) VALUES (@ConfigName, @ConfigValue)
	IF (@@ERROR <> 0)
		ROLLBACK TRAN
	ELSE
		COMMIT TRAN	
END
' 
END
GO
