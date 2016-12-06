USE [DSSPPROD_UsageAndHealth]
GO
/****** Object:  UserDefinedFunction [dbo].[fn_GetPartitionIdByType]    Script Date: 11/10/2016 4:16:42 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[fn_GetPartitionIdByType]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'CREATE FUNCTION [dbo].[fn_GetPartitionIdByType] 
(
    @TypeName nvarchar(100),
    @LogTime datetime
)
RETURNS tinyint
AS
BEGIN
    RETURN dbo.fn_GetPartitionId(@LogTime)
END
' 
END

GO
