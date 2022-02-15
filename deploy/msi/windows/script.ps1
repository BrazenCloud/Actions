$settings = Get-Content .\settings.json | ConvertFrom-Json
$settings

# length is greater than http://
if ($settings.'MSI URL'.Length -gt 7) {
    Invoke-WebRequest -Uri $settings.'MSI URL' -OutFile .\installer.msi

    if ($settings.'MSI Parameters'.Length -eq 0) {
        $settings.'MSI Parameters' = '/qn /norestart'
    }

    Write-Host 'Starting install...'
    
    Start-Process msiexec -ArgumentList "/i installer.msi $($settings.'MSI Parameters') /l* /log .\results\msi.log" -Wait

    if (Test-Path .\results\msi.log) {
        Get-Content .\results\msi.log
    }

    Write-Host 'Installation complete.'
} else {
    Write-Warning 'No URL was passed'
}