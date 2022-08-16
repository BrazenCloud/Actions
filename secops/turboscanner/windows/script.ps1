Set-Location $PSScriptRoot
$settings = Get-Content ..\settings.json | ConvertFrom-Json



if ( $settings.'Custom Parameters'.ToString().Length -gt 0 ) {
    turbo-scanner_010w.exe $($settings.'Custom Parameters') | Out-File ..\results\out.txt -Append
} else {
    turbo-scanner_010w.exe | Out-File ..\results\out.txt -Append
}
