Set-Location $PSScriptRoot
$settings = Get-Content ..\settings.json | ConvertFrom-Json



if ($settings.'Custom Parameters'.ToString().Length -gt 0) {
    & driverquery $($settings.'Custom Parameters') | Out-File ..\results\out.txt -Append
} elseif ( $settings.'Format'.ToString().Length -gt 0 ) {
    $arr = & {
        if ($settings.'Format'.ToString().Length -gt 0) {
            "/FO $($settings.'Format')"
        }
    }
    & driverquery $arr | Out-File ..\results\out.txt -Append
} else {
    driverquery | Out-File ..\results\out.txt -Append
}
