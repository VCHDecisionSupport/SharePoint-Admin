USE [DSSPPROD_UsageAndHealth]
GO
/****** Object:  DatabaseRole [SPDataAccess]    Script Date: 11/10/2016 4:16:41 PM ******/
IF NOT EXISTS (SELECT * FROM sys.database_principals WHERE name = N'SPDataAccess' AND type = 'R')
CREATE ROLE [SPDataAccess]
GO
