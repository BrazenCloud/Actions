Set-Location $PSScriptRoot
$settings = Get-Content ..\settings.json | ConvertFrom-Json



if ( $settings.'Custom Parameters'.ToString().Length -gt 0 ) {
    sfc $($settings.'Custom Parameters')
} elseif ( $settings.'Scan'.ToString() -eq 'true' ) {
    sfc /SCANNOW
} elseif ( $settings.'Verify Only'.ToString() -eq 'true' ) {
    sfc /VERIFYONLY
} elseif ( $settings.'Scan File'.ToString().Length -gt 0 ) {
    sfc /SCANFILE=$($settings.'Scan File')
} elseif ( $settings.'Verify File'.ToString().Length -gt 0 ) {
    sfc /VERIFYFILE=$($settings.'Verify File')
} else {
    sfc
}
