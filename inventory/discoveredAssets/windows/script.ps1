#region functions
Function Initialize-BcRunnerAuthentication {
    [cmdletbinding()]
    param (
        [psobject]$Settings
    )
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

    if ($PSBoundParameters.Keys -notcontains 'Settings') {
        if (Test-Path .\settings.json) {
            $Settings = Get-Content .\settings.json | ConvertFrom-Json
        } else {
            Throw 'Unable to load settings. Missing .\settings.json or the -Settings parameter.'
        }
    }

    # update nuget, if necessary
    $v = (Get-PackageProvider -Name NuGet -ListAvailable -ErrorAction SilentlyContinue).Version
    if ($null -eq $v -or $v -lt 2.8.5.201) {
        Write-Host 'Updating NuGet...'
        Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Confirm:$false -Force -Verbose
    }

    # set up the BrazenCloud module
    if (-not (Get-Module BrazenCloud -ListAvailable)) {
        Install-Module BrazenCloud -MinimumVersion 0.3.2 -Force
    }

    # set up sdk auth
    $wp = $WarningPreference
    $WarningPreference = 'SilentlyContinue'
    Import-Module BrazenCloud | Out-Null
    $WarningPreference = $wp
    $env:BrazenCloudSessionToken = Get-BrazenCloudDaemonToken -aToken $settings.atoken -Domain $settings.host
    $env:BrazenCloudSessionToken
    $env:BrazenCloudDomain = $settings.host.split('/')[-1]
}
Function Get-BcEndpointAssetHelper {
    [cmdletbinding(
        DefaultParameterSetName = 'all'
    )]
    param (
        [Parameter(Mandatory)]
        [string]$GroupId,
        [Parameter(
            ParameterSetName = 'noRunner'
        )]
        [switch]$NoRunner,
        [Parameter(
            ParameterSetName = 'hasRunner'
        )]
        [switch]$HasRunner,
        [Parameter(
            ParameterSetName = 'all'
        )]
        [switch]$All
    )
    $query = @{
        includeSubgroups = $true
        rootContainerId  = $GroupId
        skip             = 0
        take             = 1000
        sortDirection    = 0
    }
    $query['filter'] = switch ($PSCmdlet.ParameterSetName) {
        'all' {
            $null
        }
        'noRunner' {
            @{
                Left     = 'HasRunner'
                Operator = '='
                Right    = 'False'
            }
        }
        'hasRunner' {
            @{
                Left     = 'HasRunner'
                Operator = '='
                Right    = 'True'
            }
        }
    }

    $ea = Invoke-BcQueryEndpointAsset -Query $query
    $count = $ea.Items.Count
    $ea.Items
    while ($count -lt $ea.FilteredCount) {
        $query.skip = $query.skip + $query.take
        $ea = Invoke-BcQueryEndpointAsset -Query $query
        $count += $ea.Items.Count
        $ea.Items
    }
}
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
#endregion

#region Prep
Write-Host 'Initializing...'
$settings = Get-Content .\settings.json | ConvertFrom-Json
Initialize-BcRunnerAuthentication -Settings $settings

$group = (Get-BcEndpointAsset -EndpointId $settings.prodigal_object_id).Groups[0]

$ea = Get-BcEndpointAssetHelper -All -GroupId $group | Where-Object { $_.EndpointType -like 'Windows*' }
#endregion

# clear index
#Remove-BcDatastoreQuery2 -GroupId $group -IndexName $settings.'Index Name' -Query @{query = @{match_all = @{} } }

Write-Host 'Building job...'
$actions = & {
    # create installed software action
    if ($settings.'Inventory Software'.ToString() -eq 'true') {
        @{
            RepositoryActionId = (Get-BcRepository -Name 'endpoint:getInstalledSoftware').Id
            Settings           = @{
                'Computer Name'               = ($ea.Name -join ',')
                'Output Type'                 = 'json'
                'Add computer name to output' = 'true'
            }
        }
    }

    # create services action
    if ($settings.'Inventory Services'.ToString() -eq 'true') {
        @{
            RepositoryActionId = (Get-BcRepository -Name 'endpoint:getServices').Id
            Settings           = @{
                'Computer Name'               = ($ea.Name -join ',')
                'Output Type'                 = 'json'
                'Add computer name to output' = 'true'
            }
        }
    }

    @{
        RepositoryActionId = (Get-BcRepository -Name 'download:combine').Id
    }

    @{
        RepositoryActionId = (Get-BcRepository -Name 'download:brazencloudIndex').Id
        Settings           = @{
            'Index Name' = $settings.'Index Name'
        }
    }
}

# create the job
$set = New-BcSet
Add-BcSetToSet -TargetSetId $set -ObjectIds $settings.prodigal_object_id | Out-Null
$jobSplat = @{
    Name          = "Discovered Asset Inventory"
    GroupId       = $group
    EndpointSetId = $set
    IsEnabled     = $true
    IsHidden      = $false
    Actions       = $actions
    Schedule      = New-BcJobScheduleObject -ScheduleType 'RunNow' -RepeatMinutes 0
}
Write-Host 'Creating job...'
$job = New-BcJob @jobSplat