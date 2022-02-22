$settings = Get-Content .\settings.json | ConvertFrom-Json

if ((Get-Module 'ActiveDirectory' -ListAvailable).Count -ge 1) {
    $splat = @{
        Filter = $settings.Filter
    }
    $out = Get-AdFineGrainedPasswordPolicy @splat
    if ($null -ne $out) {
        if ($settings.'Only JSON'.ToString() -ne 'true') {
            $out
        }
        $out | ConvertTo-Json -Depth 1
        if ($settings.'CSV Out'.ToString() -eq 'true') {
            $out | Export-Csv .\results\fineGrainPwPolicies.csv -NoTypeInformation
        } else {
            $out | ConvertTo-Json -Depth 1 | Out-File .\results\fineGrainPwPolicies.json
        }
    }
} else {
    Write-Host 'ActiveDirectory module is not installed.'
}