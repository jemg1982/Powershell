<#
.SYNOPSIS 
Finds GPOs containing a specific string of text

.DESCRIPTION
This script will generate GPO reports for all GPOs in the enviroment and check which ones contain a specific string of text.

.INPUTS
a) Domain Name
b) String of text to search for

.OUTPUTS
List of GPOs that contain the specified string of text

.NOTES
For future development, this can be extended for the entire forest. 
#>

Import-Module GroupPolicy 

$GPOscount = 0
$GPOsdone = 0 

$DomainName = Read-Host -Prompt "In which domain do you want to search?" 
$string = Read-Host -Prompt "What string do you want to search for?" 

write-host "Finding all the GPOs in $DomainName" 

$AllGPOs = Get-GPO -All -Domain $DomainName 
$GPOscount = ($AllGPOs).count
[string[]] $MatchedGPOList = @()

Write-Host "Starting search...." 

foreach ($GPO in $AllGPOs) { 
    $report = Get-GPOReport -Guid $GPO.Id -ReportType Xml -Domain $DomainName
    $GPOsdone = $GPOsdone + 1
      if ($report -match $string) { 
        write-host "($GPOsdone of $GPOscount) ********** Match found in: $($GPO.DisplayName) **********" -foregroundcolor "Green"
        $MatchedGPOList += "$($GPO.DisplayName)";
    }
    else { 
        Write-Host " ($GPOsdone of $GPOscount) No match in: $($GPO.DisplayName)" 
    } 
} 
write-host "`r`n"
write-host "Results: **************" -foregroundcolor "Yellow"
foreach ($match in $MatchedGPOList) { 
    write-host "Match found in: $($match)" -foregroundcolor "Green"
}