﻿(Get-ADGroup -Identity "Lotus Notes" -Properties Members).Members | Get-ADUser | Select-Object name,samAccountName | Export-Csv c:\temp\lotusnotesgroup.csv