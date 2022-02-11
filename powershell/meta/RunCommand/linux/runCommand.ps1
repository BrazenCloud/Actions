# Load Settings
$json = Get-Content .\settings.json
$settings = $json | ConvertFrom-Json

if ($settings.Debug.ToString() -eq 'Debug') {
    $json.Split("`n") | Foreach-Object {"# $_"}
}

# Output PS version (debugging)
if ($settings.Debug.ToString() -eq 'Debug') {
    "# $($PSVersionTable.PSVersion.ToString())"
}

# Execute command
$sb = [scriptblock]::Create($settings.Command)
if ($settings.'Raw Output'.ToString() -eq 'true') {
    Invoke-Command -ScriptBlock $sb
} else {
    Invoke-Command -ScriptBlock $sb | ConvertTo-Xml -As String -Depth $settings.'Serialize Depth'
}