USE [DSSPPROD_UsageAndHealth]
GO
/****** Object:  StoredProcedure [dbo].[prc_CreateRole]    Script Date: 11/10/2016 4:16:41 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[prc_CreateRole]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[prc_CreateRole]
(
    @RoleName nvarchar(100)
)
AS
BEGIN
    -- Drop role members
    IF  EXISTS (SELECT * FROM sys.database_principals WHERE name = @RoleName AND type = ''R'')
        Begin
            DECLARE @RoleMemberName sysname
            DECLARE Member_Cursor CURSOR LOCAL FAST_FORWARD FOR
            select [name]
            from sys.database_principals 
            where principal_id in ( 
                select member_principal_id 
                from sys.database_role_members 
                where role_principal_id in (
                    select principal_id
                    FROM sys.database_principals where [name] = @RoleName  AND type = ''R'' ))
            OPEN Member_Cursor;
            FETCH NEXT FROM Member_Cursor
            into @RoleMemberName
            WHILE @@FETCH_STATUS = 0
                BEGIN
                    exec sp_droprolemember @rolename=@RoleName, @membername= @RoleMemberName
                    FETCH NEXT FROM Member_Cursor
                    into @RoleMemberName
                END
        CLOSE Member_Cursor;
        DEALLOCATE Member_Cursor;
        End
    DECLARE @SQL nvarchar(256)
    SET @SQL = ''IF  EXISTS (SELECT * FROM sys.database_principals WHERE name = '''''' + @RoleName + '''''' AND type = ''''R'''')\
        DROP ROLE '' + @RoleName
    exec sp_executesql @SQL
    SET @SQL =  ''CREATE ROLE '' + @RoleName
    exec sp_executesql @SQL
END
' 
END
GO
