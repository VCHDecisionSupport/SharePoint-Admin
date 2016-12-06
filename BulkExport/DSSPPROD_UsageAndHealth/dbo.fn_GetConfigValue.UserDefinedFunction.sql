USE [DSSPPROD_UsageAndHealth]
GO
/****** Object:  UserDefinedFunction [dbo].[fn_GetConfigValue]    Script Date: 11/10/2016 4:16:42 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[fn_GetConfigValue]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'CREATE FUNCTION [dbo].[fn_GetConfigValue] 
(
    @ConfigName nvarchar(255)
)
RETURNS nvarchar(255)
AS
BEGIN
    RETURN (SELECT ConfigValue FROM dbo.Configuration WHERE ConfigName = @ConfigName)
END
' 
END

GO
