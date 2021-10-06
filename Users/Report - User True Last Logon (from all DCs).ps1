<#
.SYNOPSIS 
This script finds the true last logon date of a user account.
.DESCRIPTION
The script looks for the last logon date of a user account in all domain controllers and returns the latest. 
This is useful since the last logon date is an attribute that is not replicated among domain controllers.  
.INPUTS
user account 
.OUTPUTS
User acount latest last logon date.  
.NOTES
#>

Import-Module ActiveDirectory

$username = "user123"
[datetime]::FromFileTime((Get-ADDomainController -Filter * | 
ForEach-Object {Get-ADUser $username -Properties LastLogon -Server $_.Name | 
Select-Object LastLogon} | Measure-Object -Property LastLogon -Maximum).Maximum)

