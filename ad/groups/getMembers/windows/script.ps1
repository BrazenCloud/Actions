$defaultGroupMemberProperties = @('DistinguishedName','Name','ObjectClass',
'ObjectGUID','SamAccountName','SID')

$settings = Get-Content .\settings.json | ConvertFrom-Json

if ((Get-Module 'ActiveDirectory' -ListAvailable).Count -ge 1) {
    $splat = @{
        Identity = $settings.Group
    }
    $out = Get-AdGroupMember @splat
    if ($settings.'Only JSON'.ToString() -ne 'true') {
        $out
    }
    $out | Select-Object $defaultGroupMemberProperties | ConvertTo-Json -Depth 1
    if ($settings.'CSV Out'.ToString() -eq 'true') {
        $out | Select-Object $defaultGroupMemberProperties | Export-Csv .\results\computer.csv -NoTypeInformation
    } else {
        $out | Select-Object $defaultGroupMemberProperties | ConvertTo-Json -Depth 1 | Out-File .\results\computer.json
    }
} else {
    Write-Host 'ActiveDirectory module is not installed.'
}