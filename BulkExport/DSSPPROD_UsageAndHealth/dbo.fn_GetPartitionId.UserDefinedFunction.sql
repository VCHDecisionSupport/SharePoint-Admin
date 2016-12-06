USE [DSSPPROD_UsageAndHealth]
GO
/****** Object:  UserDefinedFunction [dbo].[fn_GetPartitionId]    Script Date: 11/10/2016 4:16:42 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[fn_GetPartitionId]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'CREATE FUNCTION [dbo].[fn_GetPartitionId] 
(
    @LogTime datetime
)
RETURNS tinyint
AS
BEGIN
    DECLARE @Ret tinyint
    SELECT @Ret = DATEDIFF(dd, ''11/1/2007 00:00'', @LogTime) % (31 + 1)
    RETURN @Ret
END
' 
END

GO
