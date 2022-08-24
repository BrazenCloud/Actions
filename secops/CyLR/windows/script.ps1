Set-Location $PSScriptRoot
$settings = Get-Content ..\settings.json | ConvertFrom-Json



if ( $settings.'Custom Parameters'.ToString().Length -gt 0 ) {
    .\CyLR.exe $($settings.'Custom Parameters')
} else {
    .\CyLR.exe
}
