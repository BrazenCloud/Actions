Set-Location $PSScriptRoot
$settings = Get-Content ..\settings.json | ConvertFrom-Json



if ($settings.'Custom Parameters'.ToString().Length -gt 0) {
    & chkdsk $($settings.'Custom Parameters')
} elseif ( $settings.'Volume'.ToString().Length -gt 0 -or $settings.'Scan'.ToString() -eq 'true' ) {
    $arr = & {
        if ($settings.'Volume'.ToString().Length -gt 0) {
            "$($settings.'Volume')"
        }
        if ($settings.'Scan'.ToString() -eq 'true') {
            "/scan"
        }
    }
    & chkdsk $arr
} else {
    chkdsk
}
