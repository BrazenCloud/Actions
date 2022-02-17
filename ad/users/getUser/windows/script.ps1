$settings = Get-Content .\settings.json | ConvertFrom-Json
$settings

if ((Get-Module 'ActiveDirectory' -ListAvailable).Count -ge 1) {
    $splat = @{
        Identity = $settings.User
    }
    if ($settings.'Additional Properties') {
        $splat['Properties'] = $settings.'Additional Properties'
    }
    $out = Get-AdUser @splat
    $out
    $out | ConvertTo-Json
    $out | ConvertTo-Json | Out-File .\results\users.json
} else {
    Write-Host 'ActiveDirectory module is not installed.'
}