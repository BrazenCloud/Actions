Set-Location $PSScriptRoot
$settings = Get-Content ..\settings.json | ConvertFrom-Json



if ($settings.'Custom Parameters'.ToString().Length -gt 0) {
    & gpupdate $($settings.'Custom Parameters')
} elseif ( $settings.'Target'.ToString().Length -gt 0 -or $settings.'Force'.ToString() -eq 'true' ) {
    $arr = & {
        if ($settings.'Target'.ToString().Length -gt 0) {
            "/Target:$($settings.'Target')"
        }
        if ($settings.'Force'.ToString() -eq 'true') {
            "/Force"
        }
    }
    & gpupdate $arr
} else {
    gpupdate
}
