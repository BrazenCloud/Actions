$settings = Get-Content .\settings.json | ConvertFrom-Json
$settings

# dl the runway executable
Invoke-WebRequest -Uri 'https://runwaydownloads.blob.core.windows.net/appdl/runway.exe' -OutFile .\runway.exe

# Create the out folder
$outFolder = '.\out'
if (-not (Test-Path $outFolder)) {
    New-Item $outFolder -ItemType Directory
}

# dl the previous action results
.\runway -N -S $settings.host download --directory $outFolder

foreach ($zip in (Get-ChildItem $outFolder -Filter *.zip)) {
    Expand-Archive $zip -DestinationPath $outFolder -Force
}

# Copy the file to the destination path
Get-ChildItem $outFolder -Filter *.* | Where-Object {$_.Extension -ne '.zip'} | ForEach-Object {
    Write-Host "Copying $($_.Name) to $($settings.'File Path')"
    Copy-Item $_.FullName -Destination $settings.'File Path' -Force
}