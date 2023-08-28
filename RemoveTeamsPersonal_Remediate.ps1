#==================================================
# Script Name : RemoveTeamsPersonal_Remediate.ps1
# Synopsis    : Remediation script for Teams personal Appx
# Last update : 2023.08.21 by Josh Burkholder; script created
#==================================================

try {
  If (Get-Process msteams -ErrorAction SilentlyContinue) {
    try { Stop-Process msteams -Force } catch { }  # SilentlyContinue
  }
  Get-AppxPackage -Name MicrosoftTeams -AllUsers | Remove-AppxPackage -AllUsers
  Exit 0
} catch {
  $ErrorMsg = $_.Exception.Message
  Write-Error $ErrorMsg
  Exit 1
}


