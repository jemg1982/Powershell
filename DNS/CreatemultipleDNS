$ServerName = "DNSServer.contoso.com" 
$domain = "contoso.com" 

Import-Csv c:\temp\dnsvc.csv | ForEach-Object { 
 
$Computer = "$($_.Computer).$domain" 
$addr = $_.IP -split "\." 
$rzone = "$($addr[2]).$($addr[1]).$($addr[0]).in-addr.arpa" 
 
dnscmd $Servername /recordadd $domain "$($_.Computer)" A "$($_.IP)" 
dnscmd $Servername /zoneadd   $rzone /primary 
dnscmd $Servername /recordadd $rzone "$($addr[3])" PTR $Computer 
}
