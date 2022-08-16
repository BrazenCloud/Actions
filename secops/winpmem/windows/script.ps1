Set-Location $PSScriptRoot
$settings = Get-Content ..\settings.json | ConvertFrom-Json



winpmem_mini_x64_rc2.exe ..\results\snapshot.bin
