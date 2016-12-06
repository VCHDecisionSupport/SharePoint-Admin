USE [DSSPPROD_UsageAndHealth]
GO
/****** Object:  StoredProcedure [dbo].[proc_GetVersion]    Script Date: 11/10/2016 4:16:42 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[proc_GetVersion]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[proc_GetVersion]
(
    @VersionId uniqueidentifier,
    @Version nvarchar(64) output
)
AS
    SET NOCOUNT ON
    SELECT
        @Version = Version
    FROM
        Versions
    WHERE
        VersionId = @VersionId
' 
END
GO
