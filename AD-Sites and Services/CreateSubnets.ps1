<#
.SYNOPSIS 
This script creates multple AD subnets

.DESCRIPTION
The script takes an input CSV file (Name,Site,Description) and creates AD subnets per each row. 

.INPUTS
Input CSV file with columns named Name, Site and Description. 

.OUTPUTS
Creates multiple AD subnets. 

.NOTES
This was created to recover subnets after a cleanup. 
#>

Import-Module ActiveDirectory

$subnets = Import-csv "C:\temp\subnets.csv" 

ForEach ($item in $subnets) 
{
$Name = $item.Name
$Site = $item.Site
$Description = $item.Description

New-ADReplicationSubnet -Name $Name -Site $Site -Description $Description
} 