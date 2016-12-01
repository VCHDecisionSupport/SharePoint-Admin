# VchDsSharePoint
General SharePoint code; usage analytics
# `CREATE-TABLE-DSSPPROD_UsageAndHealth.sql`
create destination tables (1 table per source view)

# `Bulk Import Export.ps1`
- when executed batch files: 
 - genereate xml format files (execute on source database)
 - export data into dat files  (execute on source database) 
 - and import dat files into target database  (execute on destination database; destination table must already exist)
