$settings = Get-Content ./settings.json | ConvertFrom-Json

if ((Get-Module AWS.Tools.S3 -ListAvailable).Count -lt 1) {
    Throw "This action requires the AWS.Tools.S3 module"
}

<#if ((Get-AWSCredential -ListProfileDetail).ProfileName -notcontains $settings.'Credential Profile Name') {
    Throw "Credential profile: '$($settings.'Credential Profile Name')' not found."
}#>
$splat = @{
    AccessKey = $settings.'Access Key'
    SecretKey = $settings.'Secret Key'
}

if ($settings.'All Buckets'.ToString().ToLower() -ne 'true') {
    $splat['BucketName'] = $settings.'Bucket Name'
}

Get-S3Bucket @splat | ForEach-Object {
    @{
        bucketName = $_.BucketName
        encryption = if ($settings.'Simple Output'.ToString().ToLower() -eq 'true') {
            (Get-S3BucketEncryption -BucketName $_.BucketName @splat).ServerSideEncryptionRules.Count -gt 0 ? $true : $false
        } else {
            Get-S3BucketEncryption -BucketName $_.BucketName @splat
        }
    }
} | ConvertTo-Json -Depth 5 | Tee-Object -FilePath ./results/bucketEncryption.json