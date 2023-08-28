#==================================================
# Script Name : LocalUserAccountCleanup_Remediate.ps1
# Synopsis    : Remediation script to delete unwanted local user accounts
# Description : Remove unwanted local users and their associated profiles
# Last update : 2023.08.21 by Josh Burkholder; script created
#=======================================================================

$RemoveLocalUsers = @("Setup Admin", "Local Admin", "ladmin")

ForEach ($Username in $RemoveLocalUsers) {
  $LocalUser = Get-LocalUser $Username -ErrorAction SilentlyContinue
  # If the user exists locally...
  If ($LocalUser) {
    $UserRegistryPath = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\ProfileList\$($LocalUser.SID)"
    # Delete the profile data from registry
    If ((Test-Path $UserRegistryPath) -and ($UserRegistryPath -ne "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\ProfileList\")) {
      Write-Verbose "Removing registry key $UserRegistryPath"
      $UserProfilePath = Get-ItemPropertyValue $UserRegistryPath ProfileImagePath
      Remove-Item $UserRegistryPath -Force -Confirm:$False
    }
    # Delete the user profile folder (usually at C:\Users\)
    If ((Test-Path variable:UserProfilePath) -and (Test-Path $UserProfilePath)) {
      Write-Verbose "Removing user profile from $UserProfilePath"
      Remove-Item $UserProfilePath -Recurse -Force -ErrorAction SilentlyContinue
    }
    # Remove the local user account
    try {
      Write-Verbose "Deleting local user $Username"
      $LocalUser | Remove-LocalUser -Confirm:$False
    } catch {
      $ErrorMsg = $_.Exception.Message
      Write-Error $ErrorMsg
      Exit 1
    }
  }
}

Exit 0
