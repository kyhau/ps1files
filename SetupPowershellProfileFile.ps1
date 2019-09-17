# Recreate the Powershell Profile file
New-Item -Path $Profile -Type File -Force

# Add content to the Profile file to load the custom Profile file.
Add-Content -Path $Profile -Value ". C:\Workspaces\github\workspace\windows\WindowsPowerShell\Microsoft.PowerShell_profile.ps1`n"
