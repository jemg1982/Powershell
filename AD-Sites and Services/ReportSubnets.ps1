<#
.SYNOPSIS 
Creates a report of all the subnets in AD Sites and Services

.DESCRIPTION
The script lists all the subnets in AD sites and servcies and creates a report. 

.INPUTS
None

.OUTPUTS
Creates AD subnets report. 

.NOTES

#>


Import-Module ActiveDirectory
$Subnets = Get-ADReplicationSubnet -filter * -Properties * | Select Name, Site, Location, Description
$ResultsArray = @()

ForEach ($Subnet in $Subnets) {

    $SiteName = ""
    If ($Subnet.Site -ne $null) { $SiteName = $Subnet.Site.Split(',')[0].Trim('CN=') }
    
    $RA = New-Object PSObject
    $RA | Add-Member -type NoteProperty -name "Name"   -Value $Subnet.Name
    $RA | Add-Member -type NoteProperty -name "Site" -Value $SiteName
    $RA | Add-Member -type NoteProperty -name "Description" -Value $Subnet.Description

    $ResultsArray += $RA
}

$ResultsArray | Sort Subnet | Export-Csv C:\temp\AD-Subnets.csv -nti
$Report = Get-Content c:\temp\AD-Subnets.csv
$Report.Replace('","',",").TrimStart('"').TrimEnd('"') | Out-File c:\temp\AD-Subnets.csv -Force -Confirm:$false