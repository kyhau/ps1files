Write-Host("Started loading " + $MyInvocation.MyCommand.Definition + "...")

#Set-Location $env:USERPROFILE
Set-Location C:\Workspaces
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
Write-Host("Checking ExecutionPolicy... " + $currExePolicy);


###############################################################################
# Rename title indicating custom configuration applied
$psTitle = (Get-Host).UI.RawUI.WindowTitle
(Get-Host).UI.RawUI.WindowTitle = $env:USERNAME + "'s $psTitle -'.'-"


###############################################################################
# Set aliases
Write-Host "Setting aliases..."

Set-Alias ll ls
set-alias grep 'findstr'
set-alias edit "$env:ProgramFiles\Notepad++\notepad++.exe"

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
Write-Host("Finished loading all startup scripts`n")
