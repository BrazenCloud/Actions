Set-Location $PSScriptRoot
$settings = Get-Content ..\settings.json | ConvertFrom-Json



if ($settings.'All'.ToString() -eq 'true') {
    ipconfig /all
}
if ($settings.'Release'.ToString() -eq 'true') {
    ipconfig /release
}
if ($settings.'Renew'.ToString() -eq 'true') {
    ipconfig /renew
}
if ($settings.'Flush DNS'.ToString() -eq 'true') {
    ipconfig /flushdns
}
if ($settings.'Register DNS'.ToString() -eq 'true') {
    ipconfig /registerdns
}
ipconfig $($settings.'Custom Parameters')
