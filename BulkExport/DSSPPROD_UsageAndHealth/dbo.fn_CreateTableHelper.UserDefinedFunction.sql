USE [DSSPPROD_UsageAndHealth]
GO
/****** Object:  UserDefinedFunction [dbo].[fn_CreateTableHelper]    Script Date: 11/10/2016 4:16:42 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[fn_CreateTableHelper]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'CREATE FUNCTION [dbo].[fn_CreateTableHelper] 
(
    @TableName sysname, 
    @PartitionId tinyint,
    @DataColumns nvarchar(3800)
)
RETURNS nvarchar(4000)
AS
BEGIN
 RETURN ''IF OBJECT_ID(''''[dbo].['' + @TableName + '']'''') IS NULL CREATE TABLE '' + ''[dbo].['' + @TableName + '']'' + ''
 (
    PartitionId tinyint, 
    RowId uniqueidentifier NOT NULL DEFAULT (NEWSEQUENTIALID()), 
    LogTime datetime NOT NULL,
    MachineName nvarchar(128) NOT NULL,
    '' + @DataColumns + ''
    RowCreatedTime datetime NOT NULL
  )''
END
' 
END

GO
