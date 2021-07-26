Import-Module ActiveDirectory

$computers = Get-Content C:\Temp\hotfix_computers.txt    
$ErrorActionPreference = 'Stop'   
 
ForEach ($computer in $computers) {   
  
  try   
    {  Get-HotFix -cn $computer | Select-Object PSComputerName,HotFixID,Description,InstalledBy,InstalledOn | export-CSV C:\temp\Hotfixes\Hotfix-$computer.csv -NoTypeInformation -Encoding UTF8  }  
  
catch    
    {  Write-Warning "System Not reachable:$computer" }   
}  
  
