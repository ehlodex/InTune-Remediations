#==================================================
# Script Name : LocalUserAccountCleanup_Detect.ps1
# Synopsis    : Detect unwanted local user accounts
# Last update : 2023.08.21 by Josh Burkholder; script created
#=======================================================================

$RemoveLocalUsers = @("Setup Admin", "Local Admin", "ladmin")

ForEach ($Username in $RemoveLocalUsers) {
  $LocalUser = Get-LocalUser $Username -ErrorAction SilentlyContinue
  # If the user exists locally...
  If ($LocalUser) {
    Write-Output "Unwanted local account found! $Username"
    Exit 1
  }
}

Write-Output "Nobody here but us chickens!"
Exit 0
