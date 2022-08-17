Set-Location $PSScriptRoot
$settings = Get-Content ..\settings.json | ConvertFrom-Json



if ($settings.'Custom Parameters'.ToString().Length -gt 0) {
    & nslookup $($settings.'Custom Parameters')
} elseif ( $settings.'Host'.ToString().Length -gt 0 -or $settings.'Server'.ToString().Length -gt 0 ) {
    $arr = & {
        if ($settings.'Host'.ToString().Length -gt 0) {
            "$($settings.'Host')"
        }
        if ($settings.'Server'.ToString().Length -gt 0) {
            "$($settings.'Server')"
        }
    }
    & nslookup $arr
} else {
    nslookup
}
