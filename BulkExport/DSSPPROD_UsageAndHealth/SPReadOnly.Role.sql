USE [DSSPPROD_UsageAndHealth]
GO
/****** Object:  DatabaseRole [SPReadOnly]    Script Date: 11/10/2016 4:16:41 PM ******/
IF NOT EXISTS (SELECT * FROM sys.database_principals WHERE name = N'SPReadOnly' AND type = 'R')
CREATE ROLE [SPReadOnly]
GO
