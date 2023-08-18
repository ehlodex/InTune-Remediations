#==================================================
# Script Name : RemoveSCCMAgent_detection.ps1
# Synopsis    : Detects System Center Configurtation Manager Agent
# Description : Determines if C:\Windows\ccmsetup\ccmsetp.exe exists
#==================================================

$ccmsetup = "C:\Windows\ccmsetup\ccmsetup.exe"

If (Test-Path $ccmsetup -PathType Leaf) {
    Write-Output "ccmsetup.exe detected!"
    Exit 1
} else {
    Write-Output "ccmsetup.exe NOT detected!"
    Exit 0
}
