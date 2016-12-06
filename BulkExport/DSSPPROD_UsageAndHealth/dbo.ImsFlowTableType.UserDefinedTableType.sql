USE [DSSPPROD_UsageAndHealth]
GO
/****** Object:  UserDefinedTableType [dbo].[ImsFlowTableType]    Script Date: 11/10/2016 4:16:41 PM ******/
IF NOT EXISTS (SELECT * FROM sys.types st JOIN sys.schemas ss ON st.schema_id = ss.schema_id WHERE st.name = N'ImsFlowTableType' AND ss.name = N'dbo')
CREATE TYPE [dbo].[ImsFlowTableType] AS TABLE(
	[ImsFlow] [nvarchar](1024) NOT NULL
)
GO
