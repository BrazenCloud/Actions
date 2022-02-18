$defaultUserProperties = @('DistinguishedName','Enabled','Givenname','Name',
'ObjectClass','ObjectGUID','SamAccountName','SID','Surname','UserPrincipalName')

$settings = Get-Content .\settings.json | ConvertFrom-Json

if ((Get-Module 'ActiveDirectory' -ListAvailable).Count -ge 1) {
    $splat = @{
        Filter = $settings.Filter
    }
    if ($settings.'Additional Properties') {
        $defaultUserProperties = $defaultUserProperties + $settings.'Additional Properties'.Split(',') | Select-Object -Unique
        $splat['Properties'] = $settings.'Additional Properties'.Split(',')
    }
    $out = Get-AdUser @splat
    $out
    $out | Select-Object $defaultUserProperties | ConvertTo-Json -Depth 1
    $out | Select-Object $defaultUserProperties | ConvertTo-Json -Depth 1 | Out-File .\results\users.json
} else {
    Write-Host 'ActiveDirectory module is not installed.'
}