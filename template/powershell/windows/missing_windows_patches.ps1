# Runas:  PowerShell.exe -ExecutionPolicy bypass -WindowStyle hidden -File (path to script) 

Clear-Host
# Variables declared here - adjust to suit the environment
$localpath = ".\results" # This is the location where the output files will drop at runtime

# Missing Windows Patches
$ErrorActionPreference = 'SilentlyContinue'

$Patches = @(
	$MUS = New-Object -com Microsoft.Update.Session
	$Usearch = $MUS.CreateUpdateSearcher()
	$Usresult = $Usearch.Search("IsInstalled=0 and Type='Software'")
	ForEach ($update in $Usresult.Updates){
	  $update | select  @{Name='Computername';Expression={ $env:COMPUTERNAME }},
	  @{Name='AuditDate';Expression={ Get-Date -Uformat %s   }},
	  @{Name='Patch';Expression={ $Update.Title }}
	}
	$ErrorActionPreference )
	
$Patches | ConvertTo-CSV -NoTypeInformation | 
Out-File $localpath\"$env:computername"-patches.csv -Encoding UTF8

