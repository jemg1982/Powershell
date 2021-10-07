<#
.SYNOPSIS 
This script creates a report of hotfixes installed on a list of servers. 

.DESCRIPTION
Takes a list of servers from a text file, cycles through the list of server names colllecting hotfixes installed and appends the results to a CSV file. 

.INPUTS
Text file with server names (servers.txt).

.OUTPUTS
CSV file with hotfixes inventory. 

.NOTES
It can easily be modified to:

1) Create a single file per server
Export-CSV C:\temp\Hotfixes\Hotfix-Inventory-$computer.csv -NoTypeInformation -Encoding UTF8

#>

Import-Module ActiveDirectory

$computers = Get-Content C:\Temp\servers.txt    
$ErrorActionPreference = 'Stop'   
 
ForEach ($computer in $computers) {   
  try   
    {  Get-HotFix -cn $computer | Select-Object PSComputerName,HotFixID,Description,InstalledBy,InstalledOn | export-CSV C:\temp\DC_Hotfix.csv -Append -NoTypeInformation -Encoding UTF8  }  
  
<#
For a separate report per server

{  Get-HotFix -cn $computer | Select-Object PSComputerName,HotFixID,Description,InstalledBy,InstalledOn | export-CSV C:\temp\DC_Hotfix-$computer.csv -NoTypeInformation -Encoding UTF8  }  
   
#>
   catch    
    {  Write-Warning "System Not reachable:$computer" }   
}  