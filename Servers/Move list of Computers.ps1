$Computers= Get-Content -Path "C:\temp\movecomp.txt"

$OU = "OU=Win10x64Std-Test,OU=Workstations,DC=cna,DC=com"

foreach ($computer in $Computers){

    Get-ADComputer $Computer | Move-ADObject -TargetPath $OU -Verbose
  
		}