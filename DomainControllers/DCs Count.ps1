Import-Module ActiveDirectory
$domains = (Get-ADForest).Domains;

foreach ($domain in $domains)

{

    Write-Host $domain
    (Get-ADDomain -Identity $domain | select -ExpandProperty ReplicaDirectoryServers).Count;
    Write-Host "";
    $totalCount = $totalCount + (Get-ADDomain -Identity $domain | select -ExpandProperty ReplicaDirectoryServers).Count;
}

Write-Host "Total domain controller count is: "$totalCount 