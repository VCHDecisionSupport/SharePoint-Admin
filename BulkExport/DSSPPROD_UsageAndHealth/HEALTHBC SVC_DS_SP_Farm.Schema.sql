USE [DSSPPROD_UsageAndHealth]
GO
/****** Object:  Schema [HEALTHBC\SVC_DS_SP_Farm]    Script Date: 11/10/2016 4:16:41 PM ******/
IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = N'HEALTHBC\SVC_DS_SP_Farm')
EXEC sys.sp_executesql N'CREATE SCHEMA [HEALTHBC\SVC_DS_SP_Farm]'

GO
