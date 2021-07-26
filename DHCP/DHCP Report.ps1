
##param for report export
param (
   [parameter(Mandatory = $true)]
   [String]$ExportPath
)

##Get list of DHCP server in Domain
$DHCPServers = Get-DhcpServerInDC
foreach ($computername in $DHCPServers)
{

Write-Host "Checking Scopes on" $computername.DnsName -ForegroundColor Green

##Export List of DHCP Servers
$computername | Export-Csv $ExportPath\DHCPServer.csv -Append -NoTypeInformation

##Scopes Variable
$scopes = Get-DHCPServerv4Scope -ComputerName $computername.DnsName |
Select-Object "Name","SubnetMask","StartRange","EndRange","ScopeID","State"


ForEach ($scope in $scopes) {
$DHCPServer = $computername.DnsName

##Export List of scopes on each server
$scope | Export-Csv $ExportPath\$DHCPServer-Scopes.csv -Append -NoTypeInformation

##Server optioin Variable
$serveroptions = Get-DHCPServerv4OptionValue -ComputerName $computername.DnsName | 
Select-Object OptionID,Name,Value,VendorClass,UserClass,PolicyName

    ForEach ($option in $serveroptions) {
    $lines = @()

##Server Option hash table.
    $Serverproperties = @{
    Name = $scope.Name
    SubnetMask = $scope.SubnetMask
    StartRange = $scope.StartRange
    EndRange = $scope.EndRange
    ScopeId = $scope.ScopeId
    OptionID = $option.OptionID
    OptionName = $option.name
    OptionValue =$option.Value
    OptionVendorClass = $option.VendorClass
    OptionUserClass = $option.UserClass
}
##OutPut resuslt from HashTable
$lines += New-Object psobject -Property $Serverproperties
$lines | select Name,SubnetMask,StartRange,EndRange,ScopeId,OptionID,OptionName,{OptionValue},OptionVendorClass,OptionUserClass |
Export-Csv $ExportPath\$dhcpserver-ServerOption.csv -Append -NoTypeInformation
    }

##Scope option Variable 
$scopeoptions = Get-DhcpServerv4OptionValue -ComputerName $computername.DnsName -ScopeId "$($scope.ScopeId)" -All | 
Select-Object OptionID,Name,Value,VendorClass,UserClass,PolicyName

    ForEach ($option2 in $scopeoptions) {
    $lines2 = @()

##Scope Option hash table
    $Scopeproperties = @{
    Name = $scope.Name
    SubnetMask = $scope.SubnetMask
    StartRange = $scope.StartRange
    EndRange = $scope.EndRange
    ScopeId = $scope.ScopeId
    OptionID = $option2.OptionID
    OptionName = $option2.name
    OptionValue =$option2.Value
    OptionVendorClass = $option2.VendorClass
    OptionUserClass = $option2.UserClass
}
##OutPut resuslt from HashTable
$lines2 += New-Object psobject -Property $Scopeproperties
$lines2 | select Name,SubnetMask,StartRange,EndRange,ScopeId,OptionID,OptionName,{OptionValue},OptionVendorClass,OptionUserClass |
Export-Csv $ExportPath\$dhcpserver-ScopeOption.csv -Append -NoTypeInformation
    }
  }
 }
