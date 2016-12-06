USE [DSSPPROD_UsageAndHealth]
GO
/****** Object:  StoredProcedure [dbo].[Search_GetQueryTags]    Script Date: 11/10/2016 4:16:42 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Search_GetQueryTags]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
    CREATE PROCEDURE [dbo].[Search_GetQueryTags]
        @applicationId uniqueIdentifier,
        @startDate datetime,
        @endDate datetime,
        @retrieveApplicationType bit,
        @retrieveResultPageUrl bit,
        @retrieveImsFlow bit,
        @retrieveTenantId bit,
        @isVerbose bit
    AS
        BEGIN
            DECLARE @Command NVARCHAR(1000)

            DECLARE @addedColumn bit
            SET @addedColumn = 0

            --- select columns
            SET @Command = ''SELECT DISTINCT''
            IF (@retrieveApplicationType = 1)
            BEGIN
                SET @Command = @Command + '' ApplicationType''
                SET @addedColumn = 1
            END

            IF (@retrieveResultPageUrl = 1)
            BEGIN
                if (@addedColumn = 1)
                BEGIN
                    SET @Command = @Command + '',''
                END
                SET @addedColumn = 1
                SET @Command = @Command + '' ResultPageUrl''
            END

            IF (@retrieveImsFlow = 1)
            BEGIN
                if (@addedColumn = 1)
                BEGIN
                    SET @Command = @Command + '',''
                END
                SET @addedColumn = 1
                SET @Command = @Command + '' ImsFlow ''
            END

            IF (@retrieveTenantId = 1)
            BEGIN
                if (@addedColumn = 1)
                BEGIN
                    SET @Command = @Command + '',''
                END
                SET @addedColumn = 1
                SET @Command = @Command + '' TenantId ''
            END

            --- table name
            SET @Command = @Command + '' FROM''
            if (@isVerbose = 1)
            BEGIN
                SET @Command = @Command + '' Search_VerboseQueryTags''
            END
            ELSE
            BEGIN
                SET @Command = @Command + '' Search_PerMinuteQueryTags''
            END

            --- constraints
            SET @Command = @Command + '' WHERE LogTime > @startDateParam AND LogTime < @endDateParam AND (@applicationIdParam = ''''00000000-0000-0000-0000-000000000000'''' OR ApplicationId = @applicationIdParam)''

            EXEC sp_executesql 
                    @Command,
                    N''@startDateParam datetime, @endDateParam datetime, @applicationIdParam uniqueidentifier'',
                    @startDateParam = @startDate,
                    @endDateParam = @endDate,
                    @applicationIdParam = @applicationId

            END
    ' 
END
GO
