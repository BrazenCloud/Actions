Set-Location $PSScriptRoot
$settings = Get-Content ..\settings.json | ConvertFrom-Json



turboscanner turbo-scanner_010w.exe localhost >> ..\results\turboscanner.txt
