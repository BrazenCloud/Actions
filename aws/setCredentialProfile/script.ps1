$settings = Get-Content ./settings.json | ConvertFrom-Json

if ((Get-Module AWS.Tools.Common -ListAvailable).Count -lt 1) {
    Throw "This action requires the AWS.Tools.Common module"
}

Set-AwsCredential -AccessKey $settings.'Access Key' -SecretKey $settings.'Secret Key' -StoreAs $settings.'Credential Profile Name'