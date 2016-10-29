# khau's profile
Write-Host("Started loading " + $MyInvocation.MyCommand.Definition + " ...`n")

Set-Location $env:USERPROFILE
$psScriptRoot = Split-Path -Parent -Path $MyInvocation.MyCommand.Definition

# Check ExecutionPolicy
Write-Host "Checking execution policy ..."
$currExePolicy = Get-ExecutionPolicy
if ($currExePolicy -eq [Microsoft.PowerShell.ExecutionPolicy]::Restricted) {
  if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole(`
    [Security.Principal.WindowsBuiltInRole] "Administrator"))
  {
    Write-Warning "You do not have Administrator rights to change ExecutionPolicy!`nPlease re-run this script as an Administrator!"
  }
  #Set-ExecutionPolicy -ExecutionPolicy RemoteSigned 
  #Set-ExecutionPolicy -ExecutionPolicy AllSigned
  Set-ExecutionPolicy -ExecutionPolicy Unrestricted
  $currExePolicy = Get-ExecutionPolicy
}
Write-Host("Done.  ExecutionPolicy: " + $currExePolicy + "`n");

# Rename title indicating custom configuration applied
$psTitle = (Get-Host).UI.RawUI.WindowTitle
(Get-Host).UI.RawUI.WindowTitle = $env:USERNAME + "'s $psTitle -'.'-"

# Find and load config file, if one exists
$psConfigFileName = $MyInvocation.MyCommand.Definition + ".config"
[hashtable]$psConfigs=@{}
if ((Test-Path -path $psConfigFileName) -eq $True) {
  Write-Host("Reading " + $psConfigFileName + " ...");
  Get-Content $psConfigFileName | foreach-object -process {
    $k = [regex]::split($_,'=');
    if(($k[0].CompareTo("") -ne 0) -and ($k[0].StartsWith("[") -ne $True) -and ($k[0].StartsWith("#") -ne $True) -and ($k[1].CompareTo("") -ne 0)) {
      if ($psConfigs.ContainsKey($k[0]) -ne $True) { $psConfigs.Add($k[0], $k[1]); }
      else { $psConfigs[$k[0]] = $k[1]; }
    }
  }
  Write-Host("Done.  Num of configs read: " + $psConfigs.Count + "`n");
}

if ($psConfigs.Contains("PsUserScriptDir")) {
  Write-Host("Adding user script directory to path ...")
  $psScriptDir = $psConfigs["PsUserScriptDir"]
  $env:path = $env:path + ";$psScriptDir"
  Write-Host("Done.`n")
}

if ($psConfigs.Contains("PsSysinternalsSuite")) {
  Write-Host("Adding SysinternalsSuite to path ...")
  $psScriptDir = $psConfigs["PsSysinternalsSuite"]
  $env:path = $env:path + ";$psScriptDir"
  Write-Host("Done.`n")
}

# Set aliases
#
Write-Host "Setting aliases ..."

if ($psConfigs.Contains("PsMemo")) {
  Set-Alias memo PS-Memo
  function PS-MEMO { notepad $psConfigs["PsMemo"] }
}

Set-Alias env Env-Path
function global:Env-Path { $env:path }

Set-Alias envf Env-Path-Format
function Env-Path-Format { $a = $env:path; $a.Split(";")  }

Set-Alias isea ISE-Run-As-Admin
function ISE-Run-As-Admin { Start-Process PowerShell_ISE -Verb RunAs }

Set-Alias printer FindDefaultPrinter
function FindDefaultPrinter { Get-WMIObject -query "Select * From Win32_Printer Where Default = TRUE" }

Set-Alias psa PS-Run-As-Admin
function PS-Run-As-Admin { Start-Process PowerShell -Verb RunAs }

Write-Host "Done.`n"


Write-Host("Finished loading " + $env:USERNAME + "'s " + $MyInvocation.MyCommand.Name)
