Set-Location $PSScriptRoot
$settings = Get-Content ..\settings.json | ConvertFrom-Json



if ( $settings.'Parameters'.ToString().Length -gt 0 ) {
    .\CyLR.exe $($settings.'Parameters')
} else {
    .\CyLR.exe
}
