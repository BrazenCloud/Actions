# Variables
$moduleCacheDir = '..\..\..\psModuleCache'
$moduleToInstall = 'PSWindowsUpdate'
$settings = Get-Content .\settings.json | ConvertFrom-Json

# Download the module
if (-not (Test-Path $moduleCacheDir -PathType Container)) {
    New-Item -Path $moduleCacheDir -ItemType Directory
}
$moduleCacheDir = (Resolve-Path '..\..\..\psModuleCache').Path
if (-not (Test-Path $moduleCacheDir\$moduleToInstall)) {
    Save-Module $moduleToInstall -Path $moduleCacheDir
}

# get the latest version
# add support for version specific module at another time
$dir = Get-ChildItem $moduleCacheDir\$moduleToInstall -Directory | ForEach-Object { 
    $_ | Add-Member -MemberType NoteProperty -Name Version -Value [version]$_.Name -PassThru
} | Sort-Object Version | Select-Object -Last 1
Import-Module "$($dir.FullName)\$moduleToInstall.psd1"

# we could, optionally, update the $env:PSModulePath variable, but this ensures that we are using the correct version.

if ($settings.'Available Updates'.ToString() -eq 'true') {
    Get-WindowsUpdate | Tee-Object -Variable out
} else {
    $props = 'OperationName', 'Date', 'KB', 'Result', 'Title'
    Get-WUHistory -MaxDate (Get-Date).AddDays("-$($settings.'History in days')") | Tee-Object -Variable out | Select-Object $props | Format-Table
}

# Write output to the results
$out | ConvertTo-Json -Depth 4 | Out-File ".\results\$($env:COMPUTERNAME)_updates.json"