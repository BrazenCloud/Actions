$settings = Get-Content .\settings.json | ConvertFrom-Json
$settings

if ($settings.'Instance Name' -eq 'Host Name') {
    $instance = $env:COMPUTERNAME
} else {
    $instance = $settings.'Instance Name'
}

Invoke-WebRequest -Uri 'https://runwaydownloads.blob.core.windows.net/appdl/runway.exe' -OutFile .\runway.exe
$outFolder = '.\out'
if (-not (Test-Path $outFolder)) {
    New-Item $outFolder -ItemType Directory
}
& .\runway.exe -N -S $settings.host download --directory $outFolder
$zips = Get-ChildItem $outFolder -Filter *.zip -Recurse -Verbose
$zips | %{
    Expand-Archive $_.fullName -DestinationPath .\
}

# Get Backup Path
[System.Reflection.Assembly]::LoadWithPartialName("Microsoft.SqlServer.Smo") | Out-Null
$i = New-Object 'Microsoft.SqlServer.Management.Smo.Server' '(local)'
$backupPath = $i.Settings.BackupDirectory

Write-Host "Backup path: $backupPath"

Copy-Item .\backup.bak -Destination $backupPath -Force

if (Test-Path .\backup.bak) {
    Restore-SqlDatabase -ServerInstance $instance -Database $settings.'DB Name' -BackupFile backup.bak
} else {
    Write-Host 'No Backup file found.'
}