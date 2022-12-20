Function Remove-BcDatastoreQuery2 {
    [cmdletbinding()]
    param (
        [Parameter(Mandatory)]
        [string]$IndexName,
        [string]$GroupId = (Get-BcAuthenticationCurrentUser).HomeContainerId,
        #example:  @{query=@{match=@{type='agentInstall'}}}
        [Parameter(Mandatory)]
        [hashtable]$Query,
        [string]$Server = $($env:BrazenCloudDomain),
        [string]$SessionToken = $($env:BrazenCloudSessionToken)
    )
    # Remove https:// or http:// and any additional forward slashes
    $Server = ($Server -replace 'https?:\/\/', '').Trim('/')
    $splat = @{
        Method  = 'Delete'
        Uri     = "https://$Server/api/v2/datastore/$IndexName/delete"
        Body    = @{
            deleteQuery = $Query
            groupId     = $GroupId
        } | ConvertTo-Json -Depth 10
        Headers = @{
            Accept         = 'application/json'
            'Content-Type' = 'application/json'
            Authorization  = "Session $SessionToken"
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
    Authorization  = "Session $auth"
    Accept         = 'application/json'
    'Content-Type' = 'application/json'
}

# Get parent group id
$group = Invoke-RestMethod -Uri "$($settings.host)/api/v2/jobs/parent-group/$($settings.job_id)" -Headers $headers

Write-Host "Group: $group"

if ($settings.'Clear Index'.ToString() -eq 'true') {
    Remove-BcDatastoreQuery2 -GroupId $group -IndexName $settings.'Index Name' -Query @{query = @{match_all = @{} } } -ErrorAction SilentlyContinue -SessionToken $auth -Server $settings.host | Out-Null
}

# Convert any CSV files
Get-ChildItem $outFolder\* -Include *.csv | ForEach-Object {
    Import-Csv $_.FullName | ConvertTo-Json | Out-File "$($_.Directory.FullName)\$($_.BaseName).json"
}

# Upload results
Get-ChildItem $outFolder\* -Include *.json, *.ndjson | ForEach-Object {
    if ($_.BaseName.Split('-').Count -eq 2) {
        $index = "$($settings.'Index Name')-$($_.BaseName.Split('-')[1])"
    } else {
        $index = $settings.'Index Name'
    }
    Write-Host "Uploading file: $($_.Name)"
    Write-Host "URI: $($settings.host)/api/v2/datastore/$index/$group"
    #$body = (Get-Content $_.FullName | ConvertFrom-Json) | ForEach-Object { ConvertTo-Json $_ -Compress -Depth 10 } | ConvertTo-Json
    $data = (Get-Content $_.FullName | ConvertFrom-Json) | ForEach-Object { ConvertTo-Json $_ -Compress -Depth 10 }
    #Write-Host "body: $body"
    if ($data.Count -gt 100) {
        $x = 0
        while ($x -lt $data.Count) {
            $body = $data[$x..$($x + 100)] | ConvertTo-Json
            Invoke-RestMethod -Method Post -Uri "$($settings.host)/api/v2/datastore/$index/$group" -Body $body -Headers $headers
            $x = $x + 100
        }
    } else {
        Invoke-RestMethod -Method Post -Uri "$($settings.host)/api/v2/datastore/$index/$group" -Body $body -Headers $headers
    }
}