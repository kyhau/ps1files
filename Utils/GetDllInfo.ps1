$ps1Name = "GetDllInfo"
$help = @"
$ps1Name
    Retrieve DLL info of all DLLs in the specified directory.

    $ps1Name <Directory Name>
"@
if ($ARGS[0] -eq "-h") { $help; break }

# Check arguments.
$a = $ARGS.length
if ($a -eq 0) { Write-Warning "Missing <Directory Name>."; break }

$dirName = $ARGS[0] + "\*.dll"
$fileList = Get-ChildItem $dirName

$dllList = @()
foreach ($dllFile in $fileList)
{
  $dllList += [System.Diagnostics.FileVersionInfo]::GetVersion($dllFile.fullname)
}

$retList = ($dllList | Where-Object {$_.CompanyName -eq "Microsoft Corporation"})

cls

$retList | Format-Table @{Label="DLL File";Expression={$_.FileName}},`
                        @{Label="Company Name";Expression={$_.CompanyName}},`
                        @{Label="Version Number";Expression={$_.FileVersion}},`
                        @{Label="File Size";Expression={"{0:n0}" -f (Get-Item $_.FileName).Length}}`
                        -auto
                  