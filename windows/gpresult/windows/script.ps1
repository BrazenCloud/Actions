Set-Location $PSScriptRoot
$settings = Get-Content ..\settings.json | ConvertFrom-Json



if ($settings.'Custom Parameters'.ToString().Length -gt 0) {
    & gpresult $($settings.'Custom Parameters')
} elseif ( $settings.'Scope'.ToString().Length -gt 0 -or $settings.'XML Format'.ToString() -eq 'true' -or $settings.'HTML Format'.ToString() -eq 'true' ) {
    $arr = & {
        if ($settings.'Scope'.ToString().Length -gt 0) {
            "/SCOPE $($settings.'Scope')"
        }
        if ($settings.'XML Format'.ToString() -eq 'true') {
            "/X ../results/gpresult.xml"
        }
        if ($settings.'HTML Format'.ToString() -eq 'true') {
            "/H ../results/gpresult.html"
        }
    }
    & gpresult $arr
} else {
    gpresult
}
