# Load Settings
$json = Get-Content .\settings.json
$json.Split("`n") | Foreach-Object {"# $_"}
$settings = $json | ConvertFrom-Json

# Output PS version (debugging)
"# $($PSVersionTable.PSVersion.ToString())"

# Switch to pwsh if requested
if ($settings.'PWSH' -eq $true -and $PSVersionTable.PSVersion.Major -le 5) {
    try {
        pwsh -command {exit}
    } catch {
        Write-Host 'PWSH is not installed. Cannot complete.'
        exit
    }
    pwsh -ExecutionPolicy Bypass -File $MyInvocation.MyCommand.Path
}

# Execute command
$sb = [scriptblock]::Create($settings.Command)
Invoke-Command -ScriptBlock $sb | ConvertTo-Xml -As String -Depth $settings.'Serialize Depth'