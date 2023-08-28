#==================================================
# Script Name : RemoveTeamsPersonal_Detect.ps1
# Synopsis    : Detection script for Teams personal AppX
# Last update : 2023.08.21 by Josh Burkholder; script created
#==================================================

$TeamsAppx = Get-AppxProvisionedPackage -Online | Where-Object { $_.PackageName -like "*MicrosoftTeams*" }

try {
  If ($TeamsAppx.DisplayName -eq "MicrosoftTeams") {
    Write-Output "Teams personal is installed"
    Exit 1
  } else {
    Write-Output "No install of Teams personal detected."
    Exit 0
  }
} catch {
  $ErrorMsg = $_.Exception.Message
  Write-Error $ErrorMsg
  Exit 1
}