$settings = Get-Content ./settings.json | ConvertFrom-Json

Write-Host "Number of AWS.Tools.S3: $((Get-Module AWS.Tools.S3 -ListAvailable).Count)"

if ((Get-Module 'AWS.Tools.S3' -ListAvailable).Count -lt 1) {
    Throw "This action requires the AWS.Tools.S3 module"
}

<#if ((Get-AWSCredential -ListProfileDetail).ProfileName -notcontains $settings.'Credential Profile Name') {
    Throw "Credential profile: '$($settings.'Credential Profile Name')' not found."
}#>

Get-S3Bucket -AccessKey $settings.'Access Key' -SecretKey $settings.'Secret Key' | ConvertTo-Json | Tee-Object -FilePath ./results/buckets.json