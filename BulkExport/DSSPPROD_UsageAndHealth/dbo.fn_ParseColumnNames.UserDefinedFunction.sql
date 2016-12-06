USE [DSSPPROD_UsageAndHealth]
GO
/****** Object:  UserDefinedFunction [dbo].[fn_ParseColumnNames]    Script Date: 11/10/2016 4:16:42 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[fn_ParseColumnNames]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'-- BUGBUG: This requires a trailing space and no carriage returns
CREATE FUNCTION [dbo].[fn_ParseColumnNames] 
(
    @ColumnNames nvarchar(3800), 
    @IsParam bit
)
RETURNS nvarchar(3800)
AS
BEGIN
    DECLARE @Pos int,
        @CommaPos int,
        @Start int,
        @Ret nvarchar(3800)
    SET @Ret = ''''
    SET @Start = 0
    SELECT @Pos = CHARINDEX('' '', @ColumnNames)
    SELECT @CommaPos = 0
    WHILE (@Pos > 0)
    BEGIN
        SELECT @Ret = @Ret +
            CASE WHEN @IsParam = 1 THEN ''@'' ELSE '''' END + LTRIM(SUBSTRING(@ColumnNames, @Start, @Pos-@Start)) + '', ''
        SELECT @CommaPos = CHARINDEX('','', @ColumnNames, @CommaPos+1)
        IF (@CommaPos > 0)
        BEGIN
            SELECT @Start = @CommaPos + 1            
            SELECT @Pos = CHARINDEX('' '', @ColumnNames, @Start+1)            
        END
        ELSE
            BREAK
    END
    RETURN @Ret
END
' 
END

GO
