$defaultGroupProperties = @('DistinguishedName','GroupCategory','GroupScope',
'Name','ObjectClass','ObjectGUID','SamAccountName','SID')

$settings = Get-Content .\settings.json | ConvertFrom-Json

if ((Get-Module 'ActiveDirectory' -ListAvailable).Count -ge 1) {
    $splat = @{
        Identity = $settings.Group
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
        $out | Select-Object $defaultGroupProperties | Export-Csv .\results\computer.csv -NoTypeInformation
    } else {
        $out | Select-Object $defaultGroupProperties | ConvertTo-Json -Depth 1 | Out-File .\results\computer.json
    }
} else {
    Write-Host 'ActiveDirectory module is not installed.'
}