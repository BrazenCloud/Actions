$settings = Get-Content .\settings.json | ConvertFrom-Json

$pathRegex = '(?<path>[a-zA-Z]:\\([^<>":\\]+\\)*([^<>":\\]+)\.[a-zA-Z0-9]+)'
$pathRegexNoSpaces = '(?<path>[a-zA-Z]:\\([^ <>":\\]+\\)*([^ <>":\\]+)\.[a-zA-Z0-9]+)'

$out = foreach ($service in (Get-CimInstance Win32_Service)) {
    if (Test-Path $service.PathName) {
        $path = $service.PathName
    } else {
        if ($service.PathName -like '*"*') {
            if ($service.PathName -match $pathRegex) {
                $path = $Matches.path
            } else {
                Write-Warning "Unable to determine path for $($service.Name)"
            }
        } else {
            if ($service.PathName -match $pathRegexNoSpaces) {
                $path = $Matches.path
            } else {
                Write-Warning "Unable to determine path for $($service.Name)"
            }
        }
    }
    [pscustomobject]@{
        Name         = $service.Name
        DisplayName  = $service.DisplayName
        Status       = $service.Status
        StartCommand = $service.PathName
        StartName    = $service.StartName
        ServiceType  = $service.ServiceType
        Path         = $path
        Hash         = (Get-FileHash -Path $path -Algorithm SHA1).Hash
        ComputerName = $service.SystemName
        State        = $service.State
        StartMode    = $service.StartMode
    }
}
$out | ConvertTo-Json | Out-File ".\results\services-$($env:COMPUTERNAME).json" -Encoding utf8