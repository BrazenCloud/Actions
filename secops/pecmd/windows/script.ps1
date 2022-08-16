Set-Location $PSScriptRoot
$settings = Get-Content ..\settings.json | ConvertFrom-Json



if ( $settings.'Directory'.ToString().Length -gt 0 ) {
    pecmd.exe -d $($settings.'Directory') --json ..\results\ --jsonf pecmdresults.json
} elseif ( $settings.'File'.ToString().Length -gt 0 ) {
    pecmd.exe -f $($settings.'File') --json ..\results\ --jsonf pecmdresults.json
} elseif ( $settings.'Parameters'.ToString().Length -gt 0 ) {
    pecmd.exe $($settings.'Parameters')
} else {
    pecmd.exe
}
