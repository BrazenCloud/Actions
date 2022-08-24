Set-Location $PSScriptRoot
$settings = Get-Content ..\settings.json | ConvertFrom-Json



if ( $settings.'Custom Parameters'.ToString().Length -gt 0 ) {
    lastactivityview.exe $($settings.'Custom Parameters')
} else {
    lastactivityview.exe
}
