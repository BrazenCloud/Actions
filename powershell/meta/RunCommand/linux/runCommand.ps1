$settings = Get-Content .\settings.json | ConvertFrom-Json
$sb = [scriptblock]::Create($settings.Command)
Invoke-Command $sb | Export-Clixml .\export.xml
Get-Content .\export.xml