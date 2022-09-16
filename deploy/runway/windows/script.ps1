if (-not (Test-Path .\settings.json)) {
    throw 'settings.json not present'
    exit 1
} else {
    $settings = Get-Content .\settings.json | ConvertFrom-Json
    $settings
}

& .\windows\runway.exe -N -S $($settings.host) deploy -r $($settings.'IP Range') -t $($settings.'Enrollment Token')