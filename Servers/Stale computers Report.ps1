<#
.SYNOPSIS 
This script creates a report of stale computer objects. 

.DESCRIPTION
The script checks the last time computer objects have changed the computer account password and compares it to a defined amount of days.
A report with these machines is created in csv format. 

.INPUTS
Amount of days of inactivity

.OUTPUTS
CSV file with the inactive computers. 

.NOTES
It can easily be modified to check other attributes or add attributes to the report. 

1) Create a single file per server
Export-CSV C:\temp\Hotfixes\Hotfix-Inventory-$computer.csv -NoTypeInformation -Encoding UTF8

#>


$DaysAgo=(Get-Date).AddDays(-90)

Get-ADComputer -Filter {PwdLastSet -lt $DaysAgo -and OperatingSystem -Like "Windows*"} -Properties Name, Enabled, PasswordLastSet,Description,OperatingSystem |
#Get-ADComputer -Filter {PwdLastSet -lt $DaysAgo -or LastLogonTimeSTamp -lt $DaysAgo -and OperatingSystem -Like "Windows*" -and OperatingSystem -NotLike "Windows *Server*"} -Properties PwdLastSet,LastLogonTimeStamp,Description,OperatingSystem |

Select-Object -Property Name, Enabled,Description,OperatingSystem

Export-Csv -Path c:\temp\possible_stale_computers.csv -NoTypeInformation