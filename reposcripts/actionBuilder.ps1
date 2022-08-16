param (
    [string]$BasePath = '.\'
)

if (-not (Get-Module BrazenCloud.ActionBuilder -ListAvailable)) { 
    Install-Module BrazenCloud.ActionBuilder -Repository PSGallery -Force
}

$abConfigs = Get-ChildItem $BasePath -Filter *.actionBuilder.json -Recurse
foreach ($config in $abConfigs) {
    $config.FullName
    Push-Location
    Set-Location $config.Directory.FullName
    Export-BcAbAction -ConfigPath $config.FullName -OutPath ./ -Verbose
    Pop-Location
}