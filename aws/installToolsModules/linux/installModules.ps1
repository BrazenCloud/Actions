$settings = Get-Content .\settings.json | ConvertFrom-Json
$settings

if ((Get-Module AWS.Tools.Installer -ListAvailable).Count -lt 1) {
    Install-Module AWS.Tools.Installer -Force -Confirm:$false -Scope AllUsers
}

foreach ($module in $settings.'Modules'.Split(',')) {
    Install-AwsToolsModule $module -Force -Confirm:$false -Scope AllUsers -RequiredVersion 4.1.178
}