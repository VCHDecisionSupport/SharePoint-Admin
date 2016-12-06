USE [DSSPPROD_UsageAndHealth]
GO
/****** Object:  UserDefinedTableType [dbo].[TenantIdTableType]    Script Date: 11/10/2016 4:16:41 PM ******/
IF NOT EXISTS (SELECT * FROM sys.types st JOIN sys.schemas ss ON st.schema_id = ss.schema_id WHERE st.name = N'TenantIdTableType' AND ss.name = N'dbo')
CREATE TYPE [dbo].[TenantIdTableType] AS TABLE(
	[TenantId] [nvarchar](1024) NOT NULL
)
GO
