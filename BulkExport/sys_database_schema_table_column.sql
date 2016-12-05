USE master
GO

IF EXISTS(SELECT 1 FROM tempdb.sys.tables WHERE name LIKE '%gcwashere_temp_sys_tables%')
BEGIN
	DROP TABLE gcwashere_temp_sys_tables;
END

CREATE TABLE #gcwashere_temp_sys_tables (
	[database_name] [nvarchar](128) NULL,
	[schema_name] [sysname] NOT NULL,
	[table_name] [sysname] NOT NULL,
	[column_name] [sysname] NULL,
	[DataType] [nvarchar](4000) NULL
) ON [PRIMARY]
GO


EXEC sp_MSforeachdb '
INSERT INTO #gcwashere_temp_sys_tables
SELECT 
	''?'' AS database_name
	,sch.name AS schema_name
	,tab.name AS table_name
	,col.name AS column_name
	,CASE 
	    WHEN typ.name LIKE ''%char%'' THEN FORMATMESSAGE(''%s(%i)'',typ.name,col.max_length)
	    ELSE typ.name
	END AS DataType
FROM ?.sys.tables AS tab
JOIN ?.sys.schemas AS sch
ON tab.schema_id = sch.schema_id
JOIN ?.sys.columns AS col
ON col.object_id = tab.object_id
JOIN ?.sys.types AS typ
ON col.user_type_id = typ.user_type_id
WHERE 1=1
ORDER BY sch.name, tab.name, col.column_id ASC'

SELECT *
FROM #gcwashere_temp_sys_tables
ORDER BY database_name, schema_name, table_name, column_name