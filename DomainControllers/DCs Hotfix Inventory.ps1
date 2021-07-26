$computers=[system.directoryservices.activedirectory.domain]::GetCurrentDomain() | ForEach-Object {$_.DomainControllers} | ForEach-Object {$_.Name} 
$ErrorActionPreference = 'Stop'
  
ForEach ($computer in $computers) {   
  
  try   
    {  Get-HotFix -cn $computer | Select-Object PSComputerName,HotFixID,Description,InstalledBy,InstalledOn | export-CSV C:\temp\Hotfixes\DC_Hotfix.csv -Append -NoTypeInformation -Encoding UTF8  }  
  
<#
For a separate report per server

{  Get-HotFix -cn $computer | Select-Object PSComputerName,HotFixID,Description,InstalledBy,InstalledOn | export-CSV C:\temp\Hotfixes\DC_Hotfix-$computer.csv -NoTypeInformation -Encoding UTF8  }  
   
#>
   catch    
    {  Write-Warning "System Not reachable:$computer" }   
}  
  