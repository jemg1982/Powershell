$DomainName = Get-ADDomain | Select-Object -ExpandProperty NetBiosname
$GroupName = "ca_devnix_RHEL_Quest"

Get-ADGroup -Identity $GroupName

Get-ADGroupMember -identity $GroupName -Recursive -Server $DomainName | 
Get-Aduser -properties Name,DisplayName,samAccountName| 
Select-Object Name,DisplayName,samAccountName | 
Export-CSV -Path C:\temp\$DomainName"-"$GroupName".csv" -NoTypeInformation -Encoding utf8 


<# Improvements 
* Error proofing
* Relative output path
*#>
