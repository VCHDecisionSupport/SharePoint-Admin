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


