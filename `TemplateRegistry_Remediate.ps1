#==================================================
# Script Name : ...Registry_Remediate.ps1
# Synopsis    : Remediate registry value for ...
# Description : ...
# Notes       : ...
# Last update : yyyy.mm.dd by Your Name Here ...
#==================================================

$RegistryPath = "HKLM:\Path\To\Key"
$RegistryName = "RegistryItem"
$RegistryValue = 0
$RegistryType = "Dword"

try {
  If(!(Test-Path $RegistryPath)) { New-Item "$RegistryPath" -Force }
  New-ItemProperty -Path $RegistryPath -Name $RegistryName -Value $RegistryValue -Type "$RegistryType" -Force
  Exit 0
} catch {
  $ErrorMsg = $_.Exception.Message
  Write-Error $ErrorMsg
  Exit 1
}