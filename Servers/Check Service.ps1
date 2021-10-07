<#
.SYNOPSIS 
This script checks the status of a service for a list of servers.  

.DESCRIPTION
Takes a list of servers from a text file, cycles through the list of server names colllecting service status and reporting it back.
.INPUTS
Text file with server names (servers.txt).

.OUTPUTS
CSV report with the results. 

.NOTES
It can easily be modified to:

Instead of taking an input file, can get domain controllers from the domain itself.
$computers=[system.directoryservices.activedirectory.domain]::GetCurrentDomain() | ForEach-Object {$_.DomainControllers} | ForEach-Object {$_.Name} 
#>



$Computers = Get-Content c:\temp\servers.txt
$Service = "Netlogon"

$ServiceResults = ForEach ($computer in $computers) {   
    try   
      {  Get-service -Computername $computer | Where-Object {$_.Name -eq $Service} |Select-Object MachineName, Name, Status }  
    catch    
      {  Write-Warning "System Not reachable:$computer" }   
  } 
  
  $ServiceResults | Export-CSV "C:\Temp\$Service - Status.csv" -NoTypeInformation -Encoding UTF8

