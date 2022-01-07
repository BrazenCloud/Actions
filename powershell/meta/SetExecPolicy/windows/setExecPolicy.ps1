$settings = Get-Content .\settings.json | ConvertFrom-Json
$settings

$sb = [scripblock]::Create("Set-ExecutionPolicy $($settings.'Execution Policy')")
if ($settings.'PWSH') {
    pwsh -command $sb
} else {
    Invoke-Command -ScriptBlock $sb
}