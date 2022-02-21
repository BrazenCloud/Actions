$defaultUserProperties = @('DistinguishedName','Enabled','Givenname','Name',
'ObjectClass','ObjectGUID','SamAccountName','SID','Surname','UserPrincipalName')

$settings = Get-Content .\settings.json | ConvertFrom-Json

if ((Get-Module 'ActiveDirectory' -ListAvailable).Count -ge 1) {
    $splat = @{
        Identity = $settings.User
    }
    if ($settings.'Additional Properties') {
        $defaultUserProperties = $defaultUserProperties + $settings.'Additional Properties'.Split(',') | Select-Object -Unique
        $splat['Properties'] = $settings.'Additional Properties'.Split(',')
    }
    $out = Get-AdUser @splat
    if ($settings.'Only JSON'.ToString() -ne 'true') {
        $out
    }
    $out | Select-Object $defaultUserProperties | ConvertTo-Json -Depth 1
    if ($settings.'CSV Out'.ToString() -eq 'true') {
        $out | Select-Object $defaultUserProperties | Export-Csv .\results\users.csv -NoTypeInformation
    } else {
        $out | Select-Object $defaultUserProperties | ConvertTo-Json -Depth 1 | Out-File .\results\user.json
    }
} else {
    Write-Host 'ActiveDirectory module is not installed.'
}