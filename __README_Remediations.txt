INTUNE REMEDIATIONS

Remediations are the preferred method to deploy and enforce settings that are
not managed through compliance policies or configuration profiles.

InTune remediations are created in pairs: a _Detect.ps1 script and a _Remediate.ps1 script.

Both files should use the same descriptive prefix that matches the remediation's "Script package
name" in InTune. Removing spaces, or replacing them with underscores, in the prefix for the file
names is recommended but not required.

Note: Microsoft uses "DetectScriptPackageName.ps1" and "RemediateScriptPackageName.ps1"