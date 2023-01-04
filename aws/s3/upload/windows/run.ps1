$settings = Get-Content .\settings.json | ConvertFrom-Json

if ((Get-Module AWS.Tools.Installer -ListAvailable).Count -lt 1) {
    Install-Module AWS.Tools.Installer -Force -Confirm:$false -Scope AllUsers
}

if ((Get-Module AWS.Tools.S3 -ListAvailable).Count -lt 1) {
    Install-AWSToolsModule AWS.Tools.S3 -Force -Confirm:$false -Scope AllUsers
}

# download the results file
..\..\..\runway -N -S $settings.host download
Set-Location .\download

foreach ($zip in (Get-ChildItem -Filter *.zip)) {
    Expand-Archive $zip.FullName -DestinationPath .\ -Force
    Remove-Item $zip.FullName -Force -Confirm:$false
}

# Copy the file to the destination path
Write-Host "Uploading the following files to S3:"
Get-ChildItem .\

$splat = @{
    BucketName = $settings.'Bucket Name'
    KeyPrefix  = $settings.Path
    Folder     = '.\'
    AccessKey  = $settings.'Access Key'
    SecretKey  = $settings.'Secret Key'
}
Write-S3Object @splat