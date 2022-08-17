Set-Location $PSScriptRoot
$settings = Get-Content ..\settings.json | ConvertFrom-Json



if ( $settings.'Custom Parameters'.ToString().Length -gt 0 ) {
    reg $($settings.'Custom Parameters')
} elseif ( $settings.'QUERY'.ToString().Length -gt 0 ) {
    reg QUERY $($settings.'QUERY')
} elseif ( $settings.'ADD'.ToString().Length -gt 0 ) {
    reg ADD $($settings.'ADD')
} elseif ( $settings.'DELETE'.ToString().Length -gt 0 ) {
    reg DELETE $($settings.'DELETE')
} elseif ( $settings.'COPY'.ToString().Length -gt 0 ) {
    reg COPY $($settings.'COPY')
} elseif ( $settings.'SAVE'.ToString().Length -gt 0 ) {
    reg SAVE $($settings.'SAVE')
} elseif ( $settings.'RESTORE'.ToString().Length -gt 0 ) {
    reg RESTORE $($settings.'RESTORE')
} elseif ( $settings.'LOAD'.ToString().Length -gt 0 ) {
    reg LOAD $($settings.'LOAD')
} elseif ( $settings.'UNLOAD'.ToString().Length -gt 0 ) {
    reg UNLOAD $($settings.'UNLOAD')
} elseif ( $settings.'COMPARE'.ToString().Length -gt 0 ) {
    reg COMPARE $($settings.'COMPARE')
} elseif ( $settings.'EXPORT'.ToString().Length -gt 0 ) {
    reg EXPORT $($settings.'EXPORT')
} elseif ( $settings.'IMPORT'.ToString().Length -gt 0 ) {
    reg IMPORT $($settings.'IMPORT')
} elseif ( $settings.'FLAGS'.ToString().Length -gt 0 ) {
    reg FLAGS $($settings.'FLAGS')
} else {
    reg
}
