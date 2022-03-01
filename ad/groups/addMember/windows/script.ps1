$settings = Get-Content .\settings.json | ConvertFrom-Json

if ((Get-Module 'ActiveDirectory' -ListAvailable).Count -ge 1) {
    $splat = @{
        Identity = $settings.Group
        Members = $settings.Members.Split(',')
    }
    Add-AdGroupMember @splat
} else {
    Write-Host 'ActiveDirectory module is not installed.'
}