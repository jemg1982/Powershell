<#
.SYNOPSIS 
This script finds the true last logon date of a all user accounts.
.DESCRIPTION
The script looks for the last logon date of each user account in all domain controllers and returns the latest. 
This is useful since the last logon date is an attribute that is not replicated among domain controllers.  
.INPUTS
user account 
.OUTPUTS
User acount latest last logon date.  
.NOTES
#>

Import-Module ActiveDirectory
 
  $DCs = Get-ADDomainController -Filter *         #Collect Domain Controllers
  $Users = Get-ADUser -Filter *                   #Collect All Users
  $Report = "C:\temp\lastLogon.csv"               #Set Report path
  
  Out-File -filepath $exportFilePath -force -InputObject "Username,LastLogonDate"   #Create file with headers
  
  foreach($user in $users)
  {
    $time = 0
    foreach($DC in $DCs)
    { 
     $currentUser = Get-ADUser -identity $User -Server $DC -Properties samaccountname,lastLogon
     if($currentUser.LastLogon -gt $time) 
      {
        $time = $currentUser.LastLogon #Store last logon from current DC
      }
    }

    $LastLogonDate = [DateTime]::FromFileTime($time)
    $NewRow = $user.SamAccountName+","+$LastLogonDate

    Out-File -filepath $Report -Append -Noclobber -InputObject $NewRow   #Send current user date to the report

    $time = 0
  }
