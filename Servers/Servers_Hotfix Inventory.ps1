Import-Module ActiveDirectory

$computers = Get-Content C:\Temp\target_computers.txt    
$ErrorActionPreference = 'Stop'   
 
ForEach ($computer in $computers) {   
  
  try   
    {  Get-HotFix -cn $computer | Select-Object PSComputerName,HotFixID,Description,InstalledBy,InstalledOn | export-CSV C:\temp\Hotfixes\Hotfix-Inventory.csv -Append -NoTypeInformation -Encoding UTF8  }  
  
catch    
    {  Write-Warning "System Not reachable:$computer" }   
}  
  
