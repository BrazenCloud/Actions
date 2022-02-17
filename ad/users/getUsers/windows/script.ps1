$defaultUserProperties = @('DistingiushedName','Enabled','Givenname','Name',
'ObjectClass','ObjectGUID','SamAccountName','SID','Surname','UserPrincipalName')

$settings = Get-Content .\settings.json | ConvertFrom-Json

if ((Get-Module 'ActiveDirectory' -ListAvailable).Count -ge 1) {
    $splat = @{
        Filter = $settings.Filter
    }
    if ($settings.'Additional Properties') {
        $splat['Properties'] = $settings.'Additional Properties'
    }
    $out = Get-AdUser @splat
    $out
    $out | Select-Object $defaultUserProperties | ConvertTo-Json
    $out | Select-Object $defaultUserProperties | ConvertTo-Json | Out-File .\results\users.json
} else {
    Write-Host 'ActiveDirectory module is not installed.'
}