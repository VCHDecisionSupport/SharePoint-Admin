USE master
GO

IF EXISTS(SELECT 1 FROM tempdb.sys.tables WHERE name LIKE '%gcwashere_temp_sys%')
BEGIN
	DROP TABLE #gcwashere_temp_sys;
END

CREATE TABLE #gcwashere_temp_sys (
	[database_name] [nvarchar](128) NULL,
	[object_type] [nvarchar](128) NULL,
	[schema_name] [sysname] NOT NULL,
	[table_name] [sysname] NOT NULL,
	[column_name] [sysname] NULL,
	[DataType] [nvarchar](4000) NULL
) ON [PRIMARY]
GO


EXEC sp_MSforeachdb '
INSERT INTO #gcwashere_temp_sys
SELECT 
	''[?]'' AS database_name
	,obj.type_desc AS object_type
	,sch.name AS schema_name
	,obj.name AS table_name
	,col.name AS column_name
	,CASE 
	    WHEN typ.name LIKE ''%char%'' THEN FORMATMESSAGE(''%s(%i)'',typ.name,col.max_length)
	    ELSE typ.name
	END AS DataType
FROM [?].sys.objects AS obj
JOIN [?].sys.schemas AS sch
ON obj.schema_id = sch.schema_id
JOIN [?].sys.columns AS col
ON col.object_id = obj.object_id
JOIN [?].sys.types AS typ
ON col.user_type_id = typ.user_type_id
WHERE 1=1
ORDER BY sch.name, obj.name, col.column_id ASC'
GO

SELECT *
FROM #gcwashere_temp_sys
ORDER BY database_name, schema_name, table_name, column_name
GO

IF EXISTS(SELECT 1 FROM tempdb.sys.tables WHERE name LIKE '%gcwashere_temp_sys%')
BEGIN
	DROP TABLE #gcwashere_temp_sys;
END