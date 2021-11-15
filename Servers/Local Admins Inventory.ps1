$StartTime = $(get-date)
$Computers = get-content c:\temp\serverstoscan.txt
$items = ($computers).count
$i = 0
$Domain = "hug.hardygroup.co.uk"

$Cred = Get-Credential

ForEach($computer in $computers) {
$i = $i + 1
invoke-command -Credential $Cred {
 $members = net localgroup administrators |
 where {$_ -AND $_ -notmatch "command completed successfully"} |
 select -skip 4
 New-Object PSObject -Property @{
 Computername = $env:COMPUTERNAME
 Group = "Administrators"
 Members=$members
 }
 } -computer $computer -HideComputerName |
 Select * -ExcludeProperty RunspaceID | Export-CSV c:\temp\local_admins_$domain.csv -NoTypeInformation -Append
 write-host "Processing $i of $items"
 }


$elapsedTime = $(get-date) - $StartTime

$totalTime = "{0:HH:mm:ss}" -f ([datetime]$elapsedTime.Ticks)
write-host "Runtime: $totalTime"