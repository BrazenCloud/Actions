$settings = Get-Content .\settings.json | ConvertFrom-Json
$sb = [scriptblock]::Create($settings.Command)
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