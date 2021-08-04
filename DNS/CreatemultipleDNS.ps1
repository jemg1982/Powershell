<#
.SYNOPSIS 
This script creates multple DNS records from an input CSV

.DESCRIPTION
The script takes an input CSV file and creates 
a DNS record (A and PTR) for each entry. For the PTR, it also creates the zone if it doesnt exists. 

.INPUTS
Input CSV file with columns named Computer and IP. 

.OUTPUTS
Creates multiple DNS records. 

.NOTES
1. Please observe the construction of the PTR record to follow your enterprise strategy or best practice. 
2. The script uses dnscmd command which is not a powershell command but a command-line interface for managing
DNS servers. 
#>


$ServerName = "DNSServer.contoso.com" 
$domain = "contoso.com" 

Import-Csv c:\temp\dnsvc.csv | ForEach-Object { 
 
$Computer = "$($_.Computer).$domain" 
$addr = $_.IP -split "\." 
$reversezone = "$($addr[2]).$($addr[1]).$($addr[0]).in-addr.arpa" 
 
dnscmd $Servername /recordadd $domain "$($_.Computer)" A "$($_.IP)" 
dnscmd $Servername /zoneadd   $reversezone /primary 
dnscmd $Servername /recordadd $reversezone "$($addr[3])" PTR $Computer 
}
