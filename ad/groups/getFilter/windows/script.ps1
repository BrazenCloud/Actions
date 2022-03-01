$defaultGroupProperties = @('DistinguishedName','GroupCategory','GroupScope',
'Name','ObjectClass','ObjectGUID','SamAccountName','SID')

$settings = Get-Content .\settings.json | ConvertFrom-Json

if ((Get-Module 'ActiveDirectory' -ListAvailable).Count -ge 1) {
    $splat = @{
        Filter = $settings.Filter
    }
    if ($settings.'Additional Properties') {
        $defaultGroupProperties = $defaultGroupProperties + $settings.'Additional Properties'.Split(',') | Select-Object -Unique
        $splat['Properties'] = $settings.'Additional Properties'.Split(',')
    }
    $out = Get-AdGroup @splat
    if ($settings.'Only JSON'.ToString() -ne 'true') {
        $out
    }
    $out | Select-Object $defaultGroupProperties | ConvertTo-Json -Depth 1
    if ($settings.'CSV Out'.ToString() -eq 'true') {
        $out | Select-Object $defaultGroupProperties | Export-Csv .\results\computers.csv -NoTypeInformation
    } else {
        $out | Select-Object $defaultGroupProperties | ConvertTo-Json -Depth 1 | Out-File .\results\computers.json
    }
} else {
    Write-Host 'ActiveDirectory module is not installed.'
}