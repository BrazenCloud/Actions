$defaultComputerProperties = @('DistinguishedName','DNSHostName','Enabled','Name',
'ObjectClass','ObjectGUID','SamAccountName','SID','UserPrincipalName')

$settings = Get-Content .\settings.json | ConvertFrom-Json

if ((Get-Module 'ActiveDirectory' -ListAvailable).Count -ge 1) {
    $splat = @{
        Identity = $settings.Computer
    }
    if ($settings.'Additional Properties') {
        $defaultComputerProperties = $defaultComputerProperties + $settings.'Additional Properties'.Split(',') | Select-Object -Unique
        $splat['Properties'] = $settings.'Additional Properties'.Split(',')
    }
    $out = Get-AdComputer @splat
    if ($settings.'Only JSON'.ToString() -ne 'true') {
        $out
    }
    $out | Select-Object $defaultComputerProperties | ConvertTo-Json -Depth 1
    if ($settings.'CSV Out'.ToString() -eq 'true') {
        $out | Select-Object $defaultComputerProperties | Export-Csv .\results\computer.csv -NoTypeInformation
    } else {
        $out | Select-Object $defaultComputerProperties | ConvertTo-Json -Depth 1 | Out-File .\results\computer.json
    }
} else {
    Write-Host 'ActiveDirectory module is not installed.'
}