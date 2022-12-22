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

$splat = @{
    AcceptAll  = $true
    AutoReboot = if ($settings.'Reboot'.ToString() -eq 'true') { $true } else { $false }
}

if ($settings.KB.Length -gt 0 -and $settings.KB -match 'KB\d+') {
    $splat['KBArticleID'] = $settings.KB
}

Install-WindowsUpdate @splat