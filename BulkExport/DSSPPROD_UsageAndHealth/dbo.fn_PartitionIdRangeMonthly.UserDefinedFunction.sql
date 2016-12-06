USE [DSSPPROD_UsageAndHealth]
GO
/****** Object:  UserDefinedFunction [dbo].[fn_PartitionIdRangeMonthly]    Script Date: 11/10/2016 4:16:42 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[fn_PartitionIdRangeMonthly]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'CREATE FUNCTION [dbo].[fn_PartitionIdRangeMonthly] 
(
    @BeginTime datetime, 
    @EndTime datetime
)
RETURNS @Partitions TABLE (PartitionId tinyint)  
AS  
BEGIN  
    DECLARE @PartitionIdBegin tinyint,  
            @PartitionIdEnd tinyint  
    SELECT @PartitionIdBegin = dbo.fn_GetPartitionId(@BeginTime),  
        @PartitionIdEnd = dbo.fn_GetPartitionId(@EndTime)  
    IF (@BeginTime > @EndTime)
    BEGIN
        RETURN;
    END
    IF DATEDIFF(dd, @BeginTime, @EndTime) <= 31
    BEGIN          
		IF (@PartitionIdBegin > @PartitionIdEnd)  
		BEGIN
			-- this is the exclusive rather than inclusive range  
			INSERT INTO @Partitions   
				SELECT PartitionId FROM dbo.MonthlyPartitions  
				WHERE (PartitionId NOT BETWEEN @PartitionIdEnd+1 AND @PartitionIdBegin-1)  
		END
		ELSE
		BEGIN
			-- include all values between the two  
			INSERT INTO @Partitions   
				SELECT PartitionId FROM dbo.MonthlyPartitions  
				WHERE PartitionId BETWEEN @PartitionIdBegin AND @PartitionIdEnd  
		END
    END  
	ELSE
    BEGIN  
        -- include all values  
        INSERT INTO @Partitions   
            SELECT PartitionId FROM dbo.MonthlyPartitions       
    END  
    RETURN  
END  
' 
END

GO
