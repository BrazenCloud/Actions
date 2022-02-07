$settings = Get-Content .\settings.json | ConvertFrom-Json
$settings

foreach ($module in $settings.'Modules'.Split(',')) {
    Install-Module $module -Repository $($settings.'Repository')
}