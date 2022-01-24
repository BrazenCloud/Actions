$settings = Get-Content .\settings.json | ConvertFrom-Json
$settings

# Output PS version (debugging)
$PSVersionTable

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

Set-ExecutionPolicy $($settings.'Execution Policy')