<#
.SYNOPSIS 
This script counts the number of domain controllers in the forest. 

.DESCRIPTION
The script collects all the domains in the forest, and proceeds to pull all the DCs per domain, show the count per domain and the total for the foest.  

.INPUTS
none

.OUTPUTS
DCs count per domain and forest on screen. 

.NOTES

#>

Import-Module ActiveDirectory

$domains = (Get-ADForest).Domains;

foreach ($domain in $domains)

{

    Write-Host $domain
    (Get-ADDomain -Identity $domain | Select-Object -ExpandProperty ReplicaDirectoryServers).Count;
    Write-Host "";
    $totalCount = $totalCount + (Get-ADDomain -Identity $domain | Select-Object -ExpandProperty ReplicaDirectoryServers).Count;
}

Write-Host "Total domain controller count is: "$totalCount 