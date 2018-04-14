$SysFiles = driverquery /si /FO CSV | ConvertFrom-CSV | Where-Object -Property IsSigned -EQ "FALSE" | Select-Object -Property InfName | Where-Object { $_.InfName -like "*.inf" } | foreach { Select-String -Path $env:SystemRoot\inf\$($_.InfName) -Pattern ServiceBinary | select-string -Pattern \.SYS } 

Split-Path -Path $SysFiles -Leaf | select -Unique | Select-String -Pattern \.SYS
