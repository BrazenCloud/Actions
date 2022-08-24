Set-Location $PSScriptRoot
$settings = Get-Content ..\settings.json | ConvertFrom-Json



if ($settings.'Custom Parameters'.ToString().Length -gt 0) {
    & tasklist $($settings.'Custom Parameters') | Out-File ..\results\out.txt -Append
} elseif ( $settings.'Show Services'.ToString() -eq 'true' -or $settings.'Output Format'.ToString().Length -gt 0 -or $settings.'Filter'.ToString().Length -gt 0 ) {
    $arr = & {
        if ($settings.'Show Services'.ToString() -eq 'true') {
            "/SVC"
        }
        if ($settings.'Output Format'.ToString().Length -gt 0) {
            "/FO $($settings.'Output Format')"
        }
        if ($settings.'Filter'.ToString().Length -gt 0) {
            "/FI $($settings.'Filter')"
        }
    }
    & tasklist $arr | Out-File ..\results\out.txt -Append
} else {
    tasklist | Out-File ..\results\out.txt -Append
}
