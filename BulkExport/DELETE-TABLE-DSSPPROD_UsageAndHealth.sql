
USE DSSPPROD_UsageAndHealth
GO

DECLARE cur CURSOR
FOR
SELECT name 
FROM sys.tables AS tab;

DECLARE @table_name varchar(100);

OPEN cur;
FETCH NEXT FROM cur INTO @table_name;


WHILE @@FETCH_STATUS = 0
BEGIN

	DECLARE @sql varchar(max);

	SELECT @sql = FORMATMESSAGE('DELETE %s;', @table_name);
	SELECT @sql AS Sql;
	EXEC(@sql);
	FETCH NEXT FROM cur INTO @table_name;

END

CLOSE cur;
DEALLOCATE cur;
