$DNSServers = Get-Content -path C:\temp\dnsservers.txt

Foreach($DNSServer in $DNSServers) {

Test-DnsServer -IPAddress $DNSServer -Zonename "contoso.com"

}
