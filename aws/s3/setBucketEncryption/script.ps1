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

$Encryptionconfig = @{ServerSideEncryptionByDefault = @{ServerSideEncryptionAlgorithm = "AES256" } }

if ($settings.'All Buckets'.ToString().ToLower() -ne 'true') {
    Set-S3BucketEncryption @splat -BucketName $settings.'Bucket Name' -ServerSideEncryptionConfiguration_ServerSideEncryptionRule $Encryptionconfig
} else {
    Get-S3Bucket @splat | ForEach-Object {
        Set-S3BucketEncryption @splat -BucketName $_.BucketName -ServerSideEncryptionConfiguration_ServerSideEncryptionRule $Encryptionconfig
    }
}