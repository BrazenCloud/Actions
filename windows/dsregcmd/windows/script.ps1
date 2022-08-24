Set-Location $PSScriptRoot
$settings = Get-Content ..\settings.json | ConvertFrom-Json



if ( $settings.'Custom Parameters'.ToString().Length -gt 0 ) {
    dsregcmd $($settings.'Custom Parameters') | Out-File ..\results\out.txt -Append
} else {
    dsregcmd | Out-File ..\results\out.txt -Append
}
