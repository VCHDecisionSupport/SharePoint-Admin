USE [DSSPPROD_UsageAndHealth]
GO
/****** Object:  UserDefinedFunction [dbo].[fn_GetDefaultMaxBytesPerPartition]    Script Date: 11/10/2016 4:16:42 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[fn_GetDefaultMaxBytesPerPartition]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'CREATE FUNCTION [dbo].[fn_GetDefaultMaxBytesPerPartition]
(
)
RETURNS bigint
AS
BEGIN
    DECLARE @SKUMax bigint,
            @SqlVersion sysname
    SELECT @SqlVersion = @@VERSION
    IF (CHARINDEX(@SqlVersion, ''Express'') > 0)
 	SET @SKUMax = 400000000 -- ~400 MB over 14 days
    ELSE
	SET @SKUMax = 6200000000 -- ~440 MB per day
    RETURN @SKUMax
END
' 
END

GO
