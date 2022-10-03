Function Remove-BcDatastoreQuery2 {
    [cmdletbinding()]
    param (
        [Parameter(Mandatory)]
        [string]$IndexName,
        [string]$GroupId = (Get-BcAuthenticationCurrentUser).HomeContainerId,
        #example:  @{query=@{match=@{type='agentInstall'}}}
        [Parameter(Mandatory)]
        [hashtable]$Query
    )
    $splat = @{
        Method  = 'Delete'
        Uri     = "https://$($env:BrazenCloudDomain)/api/v2/datastore/$IndexName/delete"
        Body    = @{
            deleteQuery = $Query
            groupId     = $GroupId
        } | ConvertTo-Json -Depth 10
        Headers = @{
            Accept         = 'application/json'
            'Content-Type' = 'application/json'
            Authorization  = "Session $($env:BrazenCloudSessionToken)"
        }
    }
    Invoke-RestMethod @splat
}
Function Get-BrazenCloudDaemonToken {
    # outputs the session token
    [OutputType([System.String])]
    [CmdletBinding()]
    param (
        [string]$aToken,
        [string]$Domain
    )
    $authResponse = Invoke-WebRequest -UseBasicParsing -Uri "$Domain/api/v2/auth/ping" -Headers @{
        Authorization = "Daemon $aToken"
    }
    
    if ($authResponse.Headers.Authorization -like 'Session *') {
        return (($authResponse.Headers.Authorization | Select-Object -First 1) -split ' ')[1]
    } else {
        Throw 'Failed auth'
        exit 1
    }
}

$settings = Get-Content .\settings.json | ConvertFrom-Json
$settings

if ($settings.'Index Name' -eq '{jobid}') {
    $settings.'Index Name' = $settings.job_id
}

$outFolder = '.\out'
if (-not (Test-Path $outFolder)) {
    New-Item $outFolder -ItemType Directory
}
& ..\..\..\runway -N -S $settings.host download --directory $outFolder

$zips = Get-ChildItem $outFolder -Filter *.zip -Recurse -Verbose
$zips | ForEach-Object {
    Expand-Archive $_.fullName -DestinationPath $outFolder
}

$auth = Get-BrazenCloudDaemonToken -aToken $settings.atoken -Domain $settings.host

$headers = @{
    Authorization  = $auth
    Accept         = 'application/json'
    'Content-Type' = 'application/json'
}

# Get parent group id
$group = Invoke-RestMethod -Uri "$($settings.host)/api/v2/jobs/parent-group/$($settings.job_id)" -Headers @{
    Authorization = "Session $auth"
}

Write-Host "Group: $group"

if ($settings.'Clear Index'.ToString() -eq 'true') {
    Remove-BcDatastoreQuery2 -GroupId $group -IndexName $settings.'Index Name' -Query @{query = @{match_all = @{} } } -ErrorAction SilentlyContinue | Out-Null
}

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