#==================================================
# Script Name : RemoveSCCMAgent_remediation.ps1
# Synopsis    : Removes System Center Configuration Manager Agent
# Description : Runs C:\Windows\ccmsetup\ccmsetup.exe /uninstall then
#               performs an extensive manual cleanup. Most of this
#               script was sourced from resources online.
#==================================================

$ccmSetup = "C:\Windows\ccmsetup\ccmsetup.exe"
$ccmServices = @("ccmsetp", "ccmexec", "smstsmgr", "cmrcservice")
$ccmFolders = @("CCM", "ccmsetup", "ccmcache")
$ccmFiles = @("SMSCFG.ini", "SMS*.mif")
$WindowsPath = $Env:WinDir
$ServicesRegistry = "HKLM:\SYSTEM\CurrentControlSet\Services"
$MicrosoftRegistry = "HKLM:\SOFTWARE\Microsoft"

Function WaitFor {
  param([string]$ccmprocessname)
  $ccmProcess = Get-Process $ccmprocessname -ErrorAction SilentlyContinue
  If ($ccmProcess) { $ccmProcess.WaitForExit() }
}

# Attempt the official uninstall method
If (Test-Path $ccmSetup -PathType Leaf) {
  try {
    Start-Process -FilePath $ccmSetup -ArgumentList "/uninstall" -Wait -NoNewWindow
    WaitFor "ccmsetup"
  } catch {
    $ErrorMsg = $_.Exception.Message
    Write-Error $ErrorMsg
    Exit 1
  }
}

# Stop services
ForEach ($ccmService in $ccmServices) {
  Stop-Service -Name $ccmService -Force -ErrorAction SilentlyContinue
}
WaitFor "ccmexec"

# Remove WMI Namespaces
Get-WmiObject -Query "SELECT * FROM __Namespace WHERE Name='ccm'" -Namespace root | Remove-WmiObject
Get-WmiObject -Query "SELECT * FROM __Namespace WHERE Name='sms'" -Namespace root\cimv2 | Remove-WmiObject

# Remove services from registry
ForEach ($ccmService in $ccmServices) {
  Remove-Item -Path $ServicesRegistry\$ccmService -Force -Recurse -ErrorAction SilentlyContinue
}

# Remove SCCM Agent from the registry
Remove-Item -Path $MicrosoftRegistry\CCM -Force -Recurse -ErrorAction SilentlyContinue
Remove-Item -Path $MicrosoftRegistry\CCMSetup -Force -Recurse -ErrorAction SilentlyContinue
Remove-Item -Path $MicrosoftRegistry\SMS -Force -Recurse -ErrorAction SilentlyContinue

# Remove SCCM Leftovers
ForEach ($ccmFolder in $ccmFolders) {
  Remove-Item $WindowsPath\$ccmFolder -Force -Recurse -ErrorAction SilentlyContinue
}
ForEach ($ccmFile in $ccmFiles) {
  Remove-Item $WindowsPath\$ccmFile -Force -ErrorAction SilentlyContinue
}

If (Test-Path $ccmSetup -PathType Leaf) { Exit 1 } else { Exit 0 }
