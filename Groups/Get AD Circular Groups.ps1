Function Get-ADCircularGroups {
    <# 
    .SYNOPSIS
        Find instances of circular nested groups.
    
    .DESCRIPTION
        A PowerShell script to find any instances of circular nested groups in the domain. 
        The program finds and reports on all groups involved in circular nesting.

        A useful feature of Active Directory is that groups can be nested. However, it is 
        possible for the group nesting to be circular. For example, if group "Grade 1" is a 
        member of group "Students", and group "Students" is a member of "School", and group 
        "School" is a member of "Grade 1", the group nesting is circular.

        This program efficiently finds all circular nested groups. It uses the 
        System.DirectoryServices.DirectorySearcher class to retrieve all group names and their 
        direct memberships. The member attribute of the groups is a collection of the 
        Distinguished Names of all direct members, but does not reveal "primary" group membership. 
        The program evaluates each group to track down members that are groups. As soon as a 
        nested member is found that is identical to any parent group, the program has found an 
        instance of circular nesting.

        The program does not report on how the groups are nested. For example, if the program 
        lists 5 groups, there are several ways the groups could be nested. There could be one 
        instance involving the 5 groups, or one instance involving 2 groups and another involving 
        3 groups. Given the group names you will need to track down how they are nested.

    .PARAMETER OU
        Name of the organizational unit where the script will look for nested groups. The OU
        will be searched recursively. When the OU parameter is omitted, the entire domain will 
        be searched.
    
    .EXAMPLE
        Find all circular groups in two different organizational units and show verbose messages.
        Get-ADCircularGroups -OU 'OU=BEL,OU=EU,DC=contoso,DC=com', 'OU=DEU,OU=EU,DC=contoso,DC=com' -Verbose
    
    .EXAMPLE
        Find all circular groups in the domain.
        Get-ADCircularGroups

    .LINK
        https://gist.github.com/infamousjoeg/98adbc546960bff0bdf6ca2e60d64178
        https://gallery.technet.microsoft.com/scriptcenter/fa4ccf4f-712e-459c-88b4-aacdb03a08d0
    
    .NOTES
        CHANGELOG
        2017/06/28 Function born
        2018/02/20 Added OU parameter, Get-Help, error handling and optimised code #>

    [CmdLetBinding()]
    Param (
        [String[]]$OU
    )

    Begin {
        Function Get-NestedGroups ($Group, $Parents) {
            <#
                .SYNOPSIS                
                    Recursive function to enumerate group members of a group.

                .DESCRIPTION
                    $GroupMembers is the hash table of all groups and their group members. 
                    If any group member matches any of the parents, we have 
                    detected an instance of circular nesting.     

                .PARAMETER Group
                    The group whose membership is being evaluated. 

                .PARAMETER Parents
                    An array of all parent groups of $Group. 
            #>

            ForEach ($Member In $GroupMembers[$Group]) {
                ForEach ($Parent In $Parents) {
                    If ($Member -eq $Parent) {
                        Write-Verbose "Found nested group '$Parent'"
                        Return $Parent
                    } 
                } 
                # Check all group members for group membership. 
                If ($GroupMembers.ContainsKey($Member)) {
                    # Add this member to array of parent groups. 
                    # However, this is not a parent for siblings. 
                    # Recursively call function to find nested groups. 
                    $Temp = $Parents 
                    Get-NestedGroups $Member ($Temp += $Member) 
                } 
            } 
        } 

        Function Get-AllGroupObjects {
            $RunSearch = {
                $Searcher = New-Object System.DirectoryServices.DirectorySearcher
                $Searcher.SearchRoot = $SearchRoot
                $Searcher.PageSize = 200
                $Searcher.SearchScope = 'subtree' 
                $Searcher.PropertiesToLoad.Add('distinguishedName') > $Null 
                $Searcher.PropertiesToLoad.Add('member') > $Null 
                $Searcher.Filter = '(objectCategory=group)' 
                $Searcher.FindAll()
            }

            if ($OU) {
                ForEach ($O in $OU) {
                    Try {
                        Write-Verbose "Search for groups in the OU '$O'"
                        $SearchRoot = New-Object System.DirectoryServices.DirectoryEntry("LDAP://$O")
                        & $RunSearch
                    }
                    Catch {
                        throw "OU '$O' incorrect: $_"
                    }
                }
            }
            else {
                Write-Verbose "Search for groups in the entire '$($env:USERDNSDOMAIN)' domain"
                $Domain = [System.DirectoryServices.ActiveDirectory.Domain]::GetCurrentDomain()
                $SearchRoot = $Domain.GetDirectoryEntry()
                & $RunSearch
            }        
        }
    }

    Process {
        Try {
            $AllGroups = Get-AllGroupObjects
            Write-Verbose "Found a total of $(($AllGroups | Measure-Object).Count) groups"

            $GroupMembers = @{} 

            <# 
                Enumerate groups and populate Hash table. The key value will be 
                the Distinguished Name of the group. The item value will be an array 
                of the Distinguished Names of all members of the group that are groups. 
                The item value starts out as an empty array, since we don't know yet 
                which members are groups. 
            #>
            ForEach ($Group In $AllGroups) { 
                $DN = [String]$Group.properties.Item('distinguishedName') 
                $GroupMembers.Add($DN, @()) 
            }
 
            <#
                Enumerate the groups again to populate the item value arrays. 
                Now we can check each member to see if it is a group. 
            #>
            ForEach ($Group In $AllGroups) { 
                $DN = [String]$Group.properties.Item('distinguishedName') 
                $Members = @($Group.properties.Item('member')) 
        
                ForEach ($Member In $Members) {
                    If ($GroupMembers.ContainsKey($Member)) {
                        $GroupMembers[$DN] += $Member 
                    } 
                } 
            } 
 
            $Groups = $GroupMembers.Keys

            $NestedGroups = ForEach ($Group In $Groups) {
                Get-NestedGroups $Group @($Group)
            }
 
            $NestedGroups

            Write-Verbose "Found '$(($NestedGroups | Measure-Object).Count)' nested groups"
        }
        Catch {
            throw "Failed retrieving circular group membership: $_"
        }
    }
    }