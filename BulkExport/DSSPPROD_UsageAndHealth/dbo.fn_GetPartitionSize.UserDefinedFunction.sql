USE [DSSPPROD_UsageAndHealth]
GO
/****** Object:  UserDefinedFunction [dbo].[fn_GetPartitionSize]    Script Date: 11/10/2016 4:16:42 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[fn_GetPartitionSize]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'CREATE FUNCTION [dbo].[fn_GetPartitionSize] (@PartitionName sysname)
RETURNS bigint
AS
BEGIN
        DECLARE @ReservedBytes bigint
        DECLARE @UsedBytes bigint
        SELECT   
            @ReservedBytes=SUM (reserved_page_count)*8*1024,
            @UsedBytes =SUM (used_page_count)*8*1024
        FROM 
            sys.dm_db_partition_stats WITH (NOLOCK)
        WHERE 
            object_id = object_id(@PartitionName)
        --Use UsedBytes if we are not close to fill the table.
        IF (@ReservedBytes-@UsedBytes)>1024*1024
        BEGIN
              SET @ReservedBytes = @UsedBytes
        END
        RETURN @ReservedBytes
END
' 
END

GO
