# Links
[SharePoint 2013 - The content databases, tables and SQL queries](http://sptechbytes.blogspot.ca/2013/07/sharepoint-2013-content-databases_15.html)

http://www.sharepointknight.com/2014/10/what-is-the-wss_logging-database/



# VchDsSharePoint
General SharePoint code; usage analytics
# `CREATE-TABLE-DSSPPROD_UsageAndHealth.sql`
create destination tables (1 table per source view)
# `Bulk Import Export.ps1`
crawls source database and generates 3 `*.bat` files
## `$BcpFormatBatFile = "SharePoint_bcp_make_format.bat"`
genereate xml format files (execute on source database)
## `$BcpExportBatFile = "SharePoint_bcp_export.bat"`
export data into dat files (execute on source database) 
## `$BcpImportBatFile = "SharePoint_bcp_import.bat"`
import dat files into target database  (execute on computer with access to `*.bat`, `*.xml`, and `*.dat` database; destination table must already exist)


