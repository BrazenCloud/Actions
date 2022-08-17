Set-Location $PSScriptRoot
$settings = Get-Content ..\settings.json | ConvertFrom-Json



if ($settings.'Custom Parameters'.ToString().Length -gt 0) {
    & ping $($settings.'Custom Parameters')
} elseif ( $settings.'Count'.ToString().Length -gt 0 -or $settings.'Resolve address to hostname'.ToString() -eq 'true' -or $settings.'Target'.ToString().Length -gt 0 ) {
    $arr = & {
        if ($settings.'Count'.ToString().Length -gt 0) {
            "-n $($settings.'Count')"
        }
        if ($settings.'Resolve address to hostname'.ToString() -eq 'true') {
            "-a"
        }
        if ($settings.'Target'.ToString().Length -gt 0) {
            "$($settings.'Target')"
        }
    }
    & ping $arr
} else {
    ping
}
