$settings = Get-Content .\settings.json | ConvertFrom-Json
$settings

if ($settings.'Instance Name' -eq 'Host Name') {
    $instance = $env:COMPUTERNAME
} else {
    $instance = $settings.'Instance Name'
}

# Get Backup Path
[System.Reflection.Assembly]::LoadWithPartialName("Microsoft.SqlServer.Smo") | Out-Null
$i = New-Object 'Microsoft.SqlServer.Management.Smo.Server' '(local)'
$backupPath = $i.Settings.BackupDirectory

Write-Host "Backup path: $backupPath"

$db = Get-SqlDatabase -ServerInstance $instance | ?{$_.Name -eq $settings.'DB Name'}
if ($null -ne $db) {
    Backup-SqlDatabase -ServerInstance $instance -Database $settings.'DB Name' -BackupFile backup.bak

    if (Test-Path $backupPath\backup.bak) {
        Copy-Item $backupPath\backup.bak -Destination .\results
    } else {
        Write-Host 'Unable to find backup file...'
    }
} else {
    Write-Host 'NO DATABASE TO BACKUP'
}