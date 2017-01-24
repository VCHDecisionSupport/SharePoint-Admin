$ExportPath = "\\SPDBSSPS008.healthbc.org\shared2\Export"

$DatFiles = Get-ChildItem -Path $ExportPath | Where-Object {$_.Length -gt 0 -and $_.Extension -eq ".dat"}

foreach($DatFile in $DatFiles)
{
    $BaseName = $DatFile.BaseName
    Invoke-Expression "bcp DSSPPROD_UsageAndHealth.dbo.$BaseName in $DatFile -f $BaseName.xml -T -F 2 -S STDBDECSUP01"
}