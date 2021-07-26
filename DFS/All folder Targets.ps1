
function Get-DfsnAllFolderTargets ($Domain)
{
    $Time = Get-Date -Format yyyy-MM
    $RootList = Get-DfsnRoot -Domain $domain
    $RootListCount = @($RootList).count
    $FolderPaths = foreach ($item in $RootList)
    {
        Get-DfsnFolder -Path "$($item.path)\*"
    }

    $FolderPathsCount = @($FolderPaths).count

    $FolderTargets = foreach ($item in $FolderPaths)
    {
        Get-DfsnFolderTarget -Path $item.Path    
    }
    $FolderTargetsCount = @($FolderTargets).count
    
    
$CountReport = @" 
Domain = $domain
Namespaces = $RootlistCount
Folder Paths = $FolderPathsCount
Folder Targets = $FolderTargetsCount
"@
    
    $FolderPaths   | Export-CSV -path "C:\Temp\$Time - $Domain - DFS Inventory - FolderPaths.csv" -NoTypeInformation
    $FolderTargets | Export-CSV -path "C:\temp\$Time - $Domain - DFS Inventory - FolderTargets.csv" -NoTypeInformation
    $CountReport   | Out-file "C:\Temp\$Time - $Domain - DFS Inventory - Count.txt"
}  

Get-DfsnAllFolderTargets -Domain 'petrochemicals.int.huntsman.com'



