<#
.SYNOPSIS 
This script creates a report of the memmbers of an AD security group over 5000 members.  

.DESCRIPTION
This script creates a report of the memmbers of an AD security group over 5000 members using a different mechanism since the regular process stops at 5000.


.INPUTS
Group name

.OUTPUTS
CSV file with group members

.NOTES
Improvements: 
* Error proofing
* Relative Output path
#>


(Get-ADGroup -Identity "Lotus Notes" -Properties Members).Members | Get-ADUser | Select-Object name,samAccountName | Export-Csv c:\temp\lotusnotesgroup.csv