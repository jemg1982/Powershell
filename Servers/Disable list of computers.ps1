
$TimeStamp = ((get-date).toshortdatestring())
$Computers = Get-Content c:\temp\disablecomputers.txt
Foreach($Computer in $Computers)
{
$Comp = Get-ADComputer -Identity $Computer -Properties description 
$Comp | Set-ADComputer -Enabled $false -Description "Disabled due to Inactivity. If need to re-enable contact Helpdesk. $timestamp, $($Comp