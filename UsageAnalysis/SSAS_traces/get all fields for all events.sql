---- https://msdn.microsoft.com/en-us/library/bb677249(v=sql.110).aspx
-- event fields

--select p.name package_name, o.name event_name, c.name event_field, c.type_name field_type, c.column_type column_type
--from sys.dm_xe_objects o
--join sys.dm_xe_packages p
--      on o.package_guid = p.guid
--join sys.dm_xe_object_columns c
--      on o.name = c.object_name
--where o.object_type = 'event'
--order by package_name, event_name


--/*
--	map of SQL Trace events map to Extended Events events and actions
--*/
---- https://msdn.microsoft.com/en-us/library/ff878264(v=sql.110).aspx

--USE MASTER;
--GO
--SELECT DISTINCT
--   tb.trace_event_id,
--   te.name AS 'Event Class',
--   em.package_name AS 'Package',
--   em.xe_event_name AS 'XEvent Name',
--   tb.trace_column_id,
--   tc.name AS 'SQL Trace Column',
--   am.xe_action_name as 'Extended Events action'
--FROM (sys.trace_events te LEFT OUTER JOIN sys.trace_xe_event_map em
--   ON te.trace_event_id = em.trace_event_id) LEFT OUTER JOIN sys.trace_event_bindings tb
--   ON em.trace_event_id = tb.trace_event_id LEFT OUTER JOIN sys.trace_columns tc
--   ON tb.trace_column_id = tc.trace_column_id LEFT OUTER JOIN sys.trace_xe_action_map am
--   ON tc.trace_column_id = am.trace_column_id
--ORDER BY te.name, tc.name




/*
	join above two queries
*/
USE MASTER;
GO
;with event_fields AS (
SELECT DISTINCT
   em.package_name, em.xe_event_name event_name
FROM (sys.trace_events te LEFT OUTER JOIN sys.trace_xe_event_map em
   ON te.trace_event_id = em.trace_event_id) LEFT OUTER JOIN sys.trace_event_bindings tb
   ON em.trace_event_id = tb.trace_event_id LEFT OUTER JOIN sys.trace_columns tc
   ON tb.trace_column_id = tc.trace_column_id LEFT OUTER JOIN sys.trace_xe_action_map am
   ON tc.trace_column_id = am.trace_column_id)
, trace_event_map AS (
select distinct p.name package_name, o.name event_name
	--p.name package_name, o.name event_name, c.name event_field, c.type_name field_type, c.column_type column_type
from sys.dm_xe_objects o
join sys.dm_xe_packages p
      on o.package_guid = p.guid
join sys.dm_xe_object_columns c
      on o.name = c.object_name
where o.object_type = 'event')
SELECT ef.package_name AS event_field_package_name,
	ef.event_name AS event_field_event_name,
	map.package_name AS map_package_name,
	map.event_name AS map_event_name
from event_fields ef
full join trace_event_map map
on ef.package_name = map.package_name
and ef.event_name = map.event_name