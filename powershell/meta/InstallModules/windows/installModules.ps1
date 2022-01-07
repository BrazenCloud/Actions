$settings = Get-Content .\settings.json | ConvertFrom-Json
$settings

foreach ($module in $settings.'Modules'.Split(',')) {
    $sb = [scripblock]::Create("Install-Module $module -Repository $($settings.'Repository')")
    if ($settings.'PWSH') {
        pwsh -command $sb
    } else {
        Invoke-Command -ScriptBlock $sb
    }
}