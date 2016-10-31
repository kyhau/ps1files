# khau's profile
Write-Host("Started loading " + $MyInvocation.MyCommand.Definition + " ...")

Set-Location $env:USERPROFILE
$psScriptRoot = Split-Path -Parent -Path $MyInvocation.MyCommand.Definition

###############################################################################
# Check ExecutionPolicy
$currExePolicy = Get-ExecutionPolicy
if ($currExePolicy -eq [Microsoft.PowerShell.ExecutionPolicy]::Bypass) {
  if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole(`
    [Security.Principal.WindowsBuiltInRole] "Administrator"))
  {
    Write-Warning "You do not have Administrator rights to change ExecutionPolicy!`nPlease re-run this script as an Administrator!"
  }
  #Set-ExecutionPolicy -ExecutionPolicy RemoteSigned 
  #Set-ExecutionPolicy -ExecutionPolicy AllSigned
  #Set-ExecutionPolicy -ExecutionPolicy Unrestricted
  Set-ExecutionPolicy -ExecutionPolicy Bypass
  $currExePolicy = Get-ExecutionPolicy
}
Write-Host("Checking ExecutionPolicy ... " + $currExePolicy);


###############################################################################
# Rename title indicating custom configuration applied
$psTitle = (Get-Host).UI.RawUI.WindowTitle
(Get-Host).UI.RawUI.WindowTitle = $env:USERNAME + "'s $psTitle -'.'-"

# Find and load config file, if one exists
$psConfigFileName = $MyInvocation.MyCommand.Definition + ".config"
[hashtable]$psConfigs=@{}
if ((Test-Path -path $psConfigFileName) -eq $True) {
  Get-Content $psConfigFileName | foreach-object -process {
    $k = [regex]::split($_,'=');
    if(($k[0].CompareTo("") -ne 0) -and ($k[0].StartsWith("[") -ne $True) -and ($k[0].StartsWith("#") -ne $True) -and ($k[1].CompareTo("") -ne 0)) {
      if ($psConfigs.ContainsKey($k[0]) -ne $True) { $psConfigs.Add($k[0], $k[1]); }
      else { $psConfigs[$k[0]] = $k[1]; }
    }
  }
  Write-Host("Checking " + $psConfigs.Count + " configs ...");
}

if ($psConfigs.Contains("PsUserScriptDir")) {
  $psScriptDir = $psConfigs["PsUserScriptDir"]
  $env:path = $env:path + ";$env:USERPROFILE\$psScriptDir"
  Write-Host("Adding user script directory (" + $psScriptDir + ") to path ...")
}

if ($psConfigs.Contains("PsSysinternalsSuite")) {
  $psScriptDir = $psConfigs["PsSysinternalsSuite"]
  $env:path = $env:path + ";$psScriptDir"
  Write-Host("Adding SysinternalsSuite to path ...")
}


###############################################################################
# Set aliases

Write-Host "Setting aliases ..."

if ($psConfigs.Contains("PsMemo")) {
  Set-Alias memo PS-Memo
  function PS-MEMO { notepad $psConfigs["PsMemo"] }
}
if ($psConfigs.Contains("DevMemo")) {
  Set-Alias memod DEV-Memo
  function DEV-MEMO { notepad $psConfigs["DevMemo"] }
}

Set-Alias notepad USER-NOTE-PAD
function USER-NOTE-PAD { Start-Process "C:\Program Files (x86)\Notepad++\notepad++.exe" -Verb RunAs }

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

Set-Alias ll ls


###############################################################################
# Color scheme

# Pane color
#
# $a = (Get-Host).UI.RawUI
# $a.ForegroundColor = "black"
# $a.BackgroundColor = "white"

# Message color
#
Write-Host "Setting message colors ..."

$a = (Get-Host).PrivateData
$a.ErrorForegroundColor    = "red"
$a.ErrorBackgroundColor    = "black"
$a.WarningForegroundColor  = "yellow"
$a.WarningBackgroundColor  = "white"
$a.DebugForegroundColor    = "magenta"
$a.DebugBackgroundColor    = "white"
$a.VerboseForegroundColor  = "cyan"
$a.VerboseBackgroundColor  = "white"
$a.ProgressForegroundColor = "green"
$a.ProgressBackgroundColor = "white"


###############################################################################
# Exiting

Write-Host("Finished loading " + $env:USERNAME + "'s " + $MyInvocation.MyCommand.Name + "`n")

