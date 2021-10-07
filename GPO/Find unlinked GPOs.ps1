<#
.SYNOPSIS 
Finds GPOs not linked to any OU

.DESCRIPTION
This script will generate GPO reports for all GPOs in the enviroment and check if they are linked to any OU at all

.INPUTS
None 

.OUTPUTS
List of GPOs not linked. 

.NOTES
For future development, this can be extended for the entire forest, since GPOs can be linked in the parent domain and not be linked in the child domain. 
#>


Import-Module GroupPolicy

Function IsNotLinked($xmldata){
    If ($xmldata.GPO.LinksTo -eq $null) {
        Return $true
    }
    
    Return $false
}

$unlinkedGPOs = @()

Get-GPO -All | ForEach-Object { $gpo = $_ ; $_ | Get-GPOReport -ReportType xml | ForEach-Object { If(IsNotLinked([xml]$_)){$unlinkedGPOs += $gpo} }}

    If ($unlinkedGPOs.Count -eq 0) {
        "No Unlinked GPO's Found"
    }
    Else{
        $unlinkedGPOs | Select-Object DisplayName,ID | format-table
    }