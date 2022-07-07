$Report = @()
$Counter = 0


#Collect all users
$Users = Get-Content "C:\temp\Users-IIQ-Request.txt"
$CountUsers = ($Users).Count

Foreach($User in $users){
    $UserGroupCollection = Get-ADPrincipalGroupMembership $user

    $UserGroupMembership = @()
    $Counter = $Counter + 1
    
    Foreach($UserGroup in $UserGroupCollection){
        $GroupDetails = Get-ADGroup -Identity $UserGroup

        $UserGroupMembership += $GroupDetails.Name
        }
    
    $Groups = $UserGroupMembership -join ‘, ‘

    $Out = New-Object PSObject
    $Out | Add-Member -MemberType noteproperty -Name Name -Value $User
    $Out | Add-Member -MemberType noteproperty -Name Groups -Value $Groups
    $Out | Export-Csv -Path ‘C:\Temp\Output-IIQ-Request.csv’ -Append -NoTypeInformation
    write-host "Processing " $counter " of " $CountUsers 
    }
