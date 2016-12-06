USE [DSSPPROD_UsageAndHealth]
GO
/****** Object:  UserDefinedFunction [dbo].[fn_TruncateUnusedPartitionsHelper]    Script Date: 11/10/2016 4:16:42 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[fn_TruncateUnusedPartitionsHelper]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'CREATE FUNCTION [dbo].[fn_TruncateUnusedPartitionsHelper]
(
	@ProviderName sysname,
	@CurrentRetention tinyint,
	@NewRetention tinyint
)
RETURNS nvarchar(4000)
AS
BEGIN
    DECLARE @cntr tinyint
    DECLARE @SQL nvarchar(4000)
    DECLARE @Partitions table (PartitionId tinyint)
    DECLARE @Max smallint
    SELECT @Max = @NewRetention * -1;
    -- Find the partitions we want to retain.
    INSERT INTO @Partitions select PartitionId from dbo.fn_PartitionIdRangeMonthly(dateadd(day, @Max, getutcdate()), getutcdate())    
    SET @SQL = N''''
    SELECT @cntr = 0
    WHILE (@cntr <= 31)
    BEGIN
        -- If the partition is not one we want to retain ...
	IF NOT EXISTS (select 1 from @Partitions where PartitionId = @cntr)
	BEGIN
	    -- ... append a SQL command for truncating the partition.
	    SELECT @SQL = @SQL + '' TRUNCATE TABLE '' + @ProviderName + ''_Partition'' + cast(@cntr as nvarchar) + '';''
	END
	SELECT @cntr = @cntr + 1
    END
    RETURN @SQL
END
' 
END

GO
