Function Initialize-BcRunnerAuthentication {
    [cmdletbinding()]
    param (
        [psobject]$Settings,
        [Parameter(
            ParameterSetName = 'byVersion'
        )]
        [version]$ModuleVersion,
        [Parameter(
            ParameterSetName = 'byVersion'
        )]
        [string]$Prerelease,
        [Parameter(
            ParameterSetName = 'latest'
        )]
        [switch]$Latest
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

    Function Test-ModulePresent {
        [CmdletBinding()]
        param (
            [string]$Name,
            [version]$Version,
            [string]$Prerelease
        )
        $modules = Get-Module $Name -ListAvailable
        foreach ($module in $modules) {
            if ($module.Version -eq $Version) {
                if ($PSBoundParameters.Keys -contains 'Prerelease') {
                    if ($module.PrivateData.PSData.Prerelease -eq $Prerelease) {
                        return $true
                    }
                } else {
                    return $true
                }
            }
        }
        return $false
    }

    if ($PSBoundParameters.Keys -notcontains 'Settings') {
        if (Test-Path .\settings.json) {
            $Settings = Get-Content .\settings.json | ConvertFrom-Json
        } else {
            Throw 'Unable to load settings. Missing .\settings.json or the -Settings parameter.'
        }
    }

    $global:settings = $Settings

    # update nuget, if necessary
    $v = (Get-PackageProvider -Name NuGet -ListAvailable -ErrorAction SilentlyContinue).Version
    if ($null -eq $v -or $v -lt 2.8.5.201) {
        Write-Host 'Updating NuGet...'
        Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Confirm:$false -Force -Verbose
    }

    if (-not (Test-ModulePresent -Name PowerShellGet -Version 2.2.5)) {
        Write-Host 'Updating PowerShellGet...'
        Install-Module PowerShellGet -RequiredVersion 2.2.5 -Force
        Import-Module PowerShellGet -Version 2.2.5
    }

    # find latest version
    if ($Latest.IsPresent) {
        $module = Find-Module BrazenCloud
        $ModuleVersion = $module.Version
    }

    # set up the BrazenCloud module
    if (-not (Test-ModulePresent -Name BrazenCloud -Version $ModuleVersion -Prerelease $Prerelease)) {
        $reqVersion = if ($Prerelease.Length -gt 0) {
            "$ModuleVersion-$Prerelease"
        } else {
            $ModuleVersion.ToString()
        }
        $splat = @{
            Name            = 'BrazenCloud'
            RequiredVersion = $reqVersion
            AllowPrerelease = ($Prerelease.Length -gt 0)
            Force           = $true
        }
        $splat | ConvertTo-Json
        Install-Module @splat
    }

    # set up sdk auth
    Import-Module BrazenCloud -Version $ModuleVersion -WarningAction SilentlyContinue
    Get-Module BrazenCloud
    $env:BrazenCloudSessionToken = Get-BrazenCloudDaemonToken -aToken $settings.atoken -Domain $settings.host
    $env:BrazenCloudDomain = $settings.host.split('/')[-1]
}
Initialize-BcRunnerAuthentication -Settings (Get-Content .\settings.json | ConvertFrom-Json) -Latest -WarningAction SilentlyContinue
#endregion
Write-Host 'Initialization complete, commencing action...'
<#
{
    "DnsName": "EC2AMAZ-9AC6AE7.us-west-2.compute.internal",
    "EndpointType": "Windows64",
    "GatewayAddress": "172.31.0.1",
    "HardwareProduct": "Xen HVM domU",
    "Interfaces": [
        {
            "DnsName": "EC2AMAZ-9AC6AE7.us-west-2.compute.internal",
            "GatewayAddress": "172.31.0.1",
            "IpAddress": "172.31.0.90",
            "MacAddress": "0A-B6-B2-2F-DD-0F"
        }
    ],
    "LocalName": "EC2AMAZ-9AC6AE7",
    "MacAddress": "0A-B6-B2-2F-DD-0F",
    "UniqueFingerprint": "0A-B6-B2-2F-DD-0F"
}
#>

$arpHt = @{}
arp -a | Where-Object { $_ -like ' *' } | ForEach-Object { $_.Trim() -replace '  +', ';' } | ConvertFrom-Csv -Delimiter ';' | ForEach-Object {
    $arpHt[$_.'Internet Address'] = $_.'Physical Address'.Trim()
}

$map = foreach ($searchBase in $settings.'Search Base'.Split(';')) {
    Write-Host "Searching '$searchBase'"
    foreach ($computer in (Get-ADComputer -Filter * -SearchBase $searchBase -Property OperatingSystem, IPv4Address)) {
        Write-Host "- Inventorying $($computer.Name)"
        $mac = if ($arpHt.Keys -contains $computer.IPv4Address) {
            $arpHt[$computer.IPv4Address]
        } elseif (Test-Connection $computer.IPv4Address -Count 1 -Quiet) {
            (arp -a | Where-Object { $_ -like "*$($computer.IPv4Address)*" } | Select-String -Pattern '([A-F0-9]{2}-){5}[A-F0-9]{2}').Matches.Value
        } else {
            $null
        }
        [pscustomobject]@{
            DnsName           = $computer.DnsHostName
            EndpointType      = $(if ($computer.OperatingSystem -like '*Windows*') {
                    'Windows64'
                })
            GatewayAddress    = ''
            HardwareProduct   = ''
            Interfaces        = @(
                @{
                    DnsName        = $computer.DnsHostName
                    GatewayAddress = ''
                    IpAddress      = $computer.IPv4Address
                    MacAddress     = $mac
                }
            )
            LocalName         = $computer.Name
            MacAddress        = $mac
            UniqueFingerprint = $mac
        }
    }
}


$map | ConvertTo-Json -Depth 5 | Out-File .\results\map.json
$htArr = foreach ($obj in $map) {
    $ht = @{}
    foreach ($prop in $obj.PSObject.Properties.Name) {
        $ht[$prop] = $obj.$prop
    }
    $ht
}

$groupId = if ($settings.'Group ID'.length -gt 0) {
    $settings.'Group ID'
} else {
    (Get-BcEndpointAsset -EndpointId $settings.prodigal_object_id).Groups[0]
}

Invoke-BcMapAsset -EndpointData ([BrazenCloudSdk.PowerShell.Models.IAssetMapEndpoint[]]$htArr) -GroupId $groupId