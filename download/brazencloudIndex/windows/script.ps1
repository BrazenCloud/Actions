$settings = Get-Content .\settings.json | ConvertFrom-Json
$settings

if ($settings.'Index Name' -eq '{jobid}') {
    $settings.'Index Name' = $settings.job_id
}

$outFolder = '.\out'
if (-not (Test-Path $outFolder)) {
    New-Item $outFolder -ItemType Directory
}
& .\windows\runway.exe -N -S $settings.host download --directory $outFolder

$zips = Get-ChildItem $outFolder -Filter *.zip -Recurse -Verbose
$zips | ForEach-Object {
    Expand-Archive $_.fullName -DestinationPath $outFolder
}

$authResponse = Invoke-WebRequest -UseBasicParsing -Uri "$($settings.host)/api/v2/auth/ping" -Headers @{
    Authorization = "Daemon $($settings.atoken)"
}

if ($authResponse.Headers.Authorization -like 'Session *') {
    $auth = $authResponse.Headers.Authorization | Select-Object -First 1
} else {
    Throw 'Failed auth'
    exit 1
}

Write-Host "auth: $auth"

$headers = @{
    Authorization  = $auth
    Accept         = 'application/json'
    'Content-Type' = 'application/json'
}

# Get parent group id
$group = Invoke-RestMethod -Uri "$($settings.host)/api/v2/jobs/parent-group/$($settings.job_id)" -Headers @{
    Authorization = $auth
}

Write-Host "Group: $group"

# Upload results
Get-ChildItem $outFolder\* -Include *.json, *.ndjson | ForEach-Object {
    Write-Host "Uploading file: $($_.Name)"
    Write-Host "URI: $($settings.host)/api/v2/datastore/$($settings.'Index Name')/bulk"
    $body = @{
        groupId = $group
        data    = @((Get-Content $_.FullName | ConvertFrom-Json))
    }
    ($body | ConvertTo-Json -Depth 10 -Compress) | Out-File .\results\body.json
    Invoke-RestMethod -Method Post -Uri "$($settings.host)/api/v2/datastore/$($settings.'Index Name')/bulk" -Body ($body | ConvertTo-Json -Depth 10 -Compress) -Headers $headers
}