<#
.SYNOPSIS 
This script creates a report of the memmbers of an AD security group. 

.DESCRIPTION
This scripts creates a report of the members of an AD security group, shows the general details onscreen and then creates a report in CSV with the members. 
This is recursive, which means it will get the members of any nested group inside.  

.INPUTS
Group name

.OUTPUTS
CSV file with group members

.NOTES
Improvements: 
* Error proofing
* Relative Output path
#>


$DomainName = Get-ADDomain | Select-Object -ExpandProperty NetBiosname
$GroupName = "ca_devnix_RHEL_Quest"

Get-ADGroup -Identity $GroupName

Get-ADGroupMember -identity $GroupName -Recursive -Server $DomainName | 
Get-Aduser -properties Name,DisplayName,samAccountName| 
Select-Object Name,DisplayName,samAccountName | 
Export-CSV -Path C:\temp\$DomainName"-"$GroupName".csv" -NoTypeInformation -Encoding utf8 
