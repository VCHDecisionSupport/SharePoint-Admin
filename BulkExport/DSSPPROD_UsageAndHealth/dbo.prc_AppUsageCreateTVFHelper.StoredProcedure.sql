USE [DSSPPROD_UsageAndHealth]
GO
/****** Object:  StoredProcedure [dbo].[prc_AppUsageCreateTVFHelper]    Script Date: 11/10/2016 4:16:41 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[prc_AppUsageCreateTVFHelper]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[prc_AppUsageCreateTVFHelper]
(
    @TypeName nvarchar(100),
    @Column sysname,
    @InputParameters nvarchar(4000),
    @IndexName sysname,
    @IndexFilter nvarchar(4000),
    @Debug bit = 0 
)
AS
BEGIN
    DECLARE @Error nvarchar(max)
        BEGIN TRY
            exec dbo.prc_CreateTVFHelper @TypeName,@Column,@InputParameters,@IndexName,@IndexFilter,@Debug    
        END TRY
        BEGIN CATCH
            SELECT @Error = ''Errors occurred '' + ERROR_MESSAGE()
            RAISERROR(@Error, 10, 1)
        END CATCH
END
' 
END
GO
