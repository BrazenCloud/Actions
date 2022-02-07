$settings = Get-Content .\settings.json | ConvertFrom-Json
$settings

Set-ExecutionPolicy $($settings.'Execution Policy')