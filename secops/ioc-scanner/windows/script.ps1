Set-Location $PSScriptRoot
$settings = Get-Content ..\settings.json | ConvertFrom-Json



Remove-Item hashfile.txt

Write-Output "{{$($settings.'Hash')}}"  > hashfile.txt

oc_scanner.exe -f ./hashfile.txt >> ../results/ioc-scanner.txt
