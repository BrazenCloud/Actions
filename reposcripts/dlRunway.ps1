param (
    [string]$Email,
    [string]$Password,
    [string]$Server = 'portal.runawy.host',
    [switch]$IncludeWindows
)

if (-not (Get-Module Runway -ListAvailable)) { 
    Install-Module Runway -Repository PSGallery
}

$connectSplat = @{
    Email        = $Email
    Password     = (ConvertTo-SecureString $Password -AsPlainText -Force)
    RunwayDomain = $Server
}
Connect-Runway @connectSplat

$dls = Get-RwContentPublicDownload

# DL the latest Linux executable
$l64 = $dls | Where-Object { $_.Platform -eq 'Linux64' }
Invoke-RwDownloadContentPublicFile -Id $l64.Id -OutFile ./runway.bin

# DL the latest Winows executable
$w64 = $dls | Where-Object { $_.Platform -eq 'Windows64' }
Invoke-RwDownloadContentPublicFile -Id $w64.Id -OutFile ./runway.exe

# Enable execution on the Linux executable for pipeline purposes
chmod +x ./runway.bin