Get-ChildItem c:\temp\test1 -filter "file*" | where {-not $_.PsIsContainer} | sort CreationTime -desc | select -Skip 3 | remove-Item -force
