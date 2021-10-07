<#
.SYNOPSIS 
This script will generate a GPO report of a list of servers

.DESCRIPTION
The script takes a list of servers from an input file and generates a GPO report for each server in HTML format. 

.INPUTS
Text file with list of servers 

.OUTPUTS
GPO reports in HTML format.

.NOTES
Keep in mind the scope of the GPO report (computer settings, user settings or both) since different GPOs can apply based user's group membership. 

#>

$servers = import-csv c:\temp\rsop\iglooservers.csv
$user = "User123"

foreach ($server in $servers)
(
    Get-GPResultantSetOfPolicy -user $user -computer $server -reporttype html -path c:\temp\$server - GPOReport.html
)
