Write-Host 'deploy:file'
Get-Content .\settings.json
$settings = Get-Content .\settings.json | ConvertFrom-Json
$settings

# Create the out folder
$outFolder = '.\out'
if (-not (Test-Path $outFolder)) {
    New-Item $outFolder -ItemType Directory
}

# dl the previous action results
Copy-Item ..\..\..\runway.exe -Destination .\runway.exe
Start-Process -FilePath .\runway.exe -ArgumentList "--loglevel", "trace", "-N", "-S", $settings.host, "download", "--directory", $outFolder -Wait

if ($settings.Unzip.ToString() -eq 'true') {
    foreach ($zip in (Get-ChildItem $outFolder -Filter *.zip)) {
        Expand-Archive $zip.FullName -DestinationPath $outFolder -Force
    }

    # Copy the file to the destination path
    Get-ChildItem $outFolder -Filter *.* | Where-Object { $_.Extension -ne '.zip' } | ForEach-Object {
        Write-Host "Copying $($_.Name) to $($settings.'File Path')"
        Copy-Item $_.FullName -Destination $settings.'File Path' -Force
    }
} else {
    foreach ($zip in (Get-ChildItem $outFolder -Filter *.zip)) {
        Copy-Item $zip.FullName -Destination $settings.'File Path' -Force
    }
}