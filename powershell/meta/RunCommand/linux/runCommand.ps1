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
    $output = Invoke-Command -ScriptBlock $sb
    $select = '*'
    if ($settings.'Default Properties Only' -eq $true) {
        if ($output.GetType().BaseType.Name -eq 'Array') {
            if ($output[0].PSStandardMembers.DefaultDisplayPropertySet.ReferencedPropertyNames) {
                $select = $output[0].PSStandardMembers.DefaultDisplayPropertySet.ReferencedPropertyNames
            }
        }
    }
    $output | Select-Object $select | Export-Clixml -Depth $settings.'Serialize Depth' .\results\output.clixml #ConvertTo-Xml -As String -Depth $settings.'Serialize Depth'
    Get-Content .\results\output.clixml
    Invoke-Command -ScriptBlock $sb | ConvertTo-Xml -As String -Depth $settings.'Serialize Depth'
}