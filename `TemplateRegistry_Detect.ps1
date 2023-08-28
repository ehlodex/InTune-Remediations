#==================================================
# Script Name : ...Registry_Detect.ps1
# Synopsis    : Detection registry value for ...
# Description : ...
# Notes       : ...
# Last update : yyyy.mm.dd by Your Name Here ...
#==================================================

$RegistryPath = "HKLM:\Path\To\Key"
$RegistryName = "RegistryItem"
$RegistryValue = 0

try {
  $CurrentValue = Get-ItemPropertyValue -Path $RegistryPath -Name $RegistryName
  If ($CurrentValue -eq $RegistryValue) { Exit 0 }
} catch {
    $ErrorMsg = $_.Exception.Message
    Write-Error $ErrorMsg
    Exit 1
}
Write-Output "Value is set, but not equal to $RegistryValue"
Exit 1