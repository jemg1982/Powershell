$domain = [System.Directoryservices.Activedirectory.Domain]::GetCurrentDomain()
$domain | ForEach-Object {$_.DomainControllers} | 
ForEach-Object {
  $hostEntry= [System.Net.Dns]::GetHostByName($_.Name)
  New-Object -TypeName PSObject -Property @{
      Name = $_.Name
      IPAddress = $hostEntry.AddressList[0].IPAddressToString
     }
} | Export-CSV "C:\temp\DomainControllersIP.csv" -NoTypeInformation -Encoding UTF8