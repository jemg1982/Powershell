
<#
.SYNOPSIS 
This script deletes multple AD subnets

.DESCRIPTION
The script takes an input CSV file (Name) and deletes the corresponding AD subnets per each row. 

.INPUTS
Input CSV file with columns named Name

.OUTPUTS
Deletes multiple AD subnets. 

.NOTES
This was created to delete subnets for a cleanup. 
#>

Import-Module ActiveDirectory

$subnets = Import-csv "C:\tools\Scripts\Subnets\subnets.csv" 

ForEach ($item in $subnets) 
{
$Name = $item.Name
 
Remove-ADReplicationSubnet -Identity $Name -Confirm:$false
}