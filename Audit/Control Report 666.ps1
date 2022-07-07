$Time = Get-Date -Format yyyy-MM

Get-ADUser -Filter * -Properties Name,SamAccountName,WhenCreated,Enabled,DistinguishedName,UserPrincipalName,GivenName,SurName,ObjectClass,ObjectGUID,SID | 
sort whencreated |
Export-Csv C:\temp\Control666-$Time.csv -NoTypeInformation