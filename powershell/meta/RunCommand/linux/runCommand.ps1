$settings = Get-Content .\settings.json | ConvertFrom-Json
$sb = [scriptblock]::Create($settings.Command)
Invoke-Command $sb | ConvertTo-Xml -As String -Depth $settings.'Serialize Depth'