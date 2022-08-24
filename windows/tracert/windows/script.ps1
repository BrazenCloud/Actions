Set-Location $PSScriptRoot
$settings = Get-Content ..\settings.json | ConvertFrom-Json



if ($settings.'Custom Parameters'.ToString().Length -gt 0) {
    & tracert $($settings.'Custom Parameters')
} elseif ( $settings.'Skip Resolving'.ToString() -eq 'true' -or $settings.'Max hops'.ToString().Length -gt 0 -or $settings.'timeout'.ToString().Length -gt 0 -or $settings.'Target Name'.ToString().Length -gt 0 ) {
    $arr = & {
        if ($settings.'Skip Resolving'.ToString() -eq 'true') {
            "-d"
        }
        if ($settings.'Max hops'.ToString().Length -gt 0) {
            "-h $($settings.'Max hops')"
        }
        if ($settings.'timeout'.ToString().Length -gt 0) {
            "-w $($settings.'timeout')"
        }
        if ($settings.'Target Name'.ToString().Length -gt 0) {
            "$($settings.'Target Name')"
        }
    }
    & tracert $arr
} else {
    tracert
}
