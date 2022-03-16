if ((Get-WindowsFeature ADCS-Cert-Authority).Installed) {
    $settings = Get-Content .\settings.json | ConvertFrom-Json
    $settings
    Copy-Item .\settings.json -Destination C:\Temp
    # dl previous action results
    Invoke-WebRequest -Uri 'https://runwaydownloads.blob.core.windows.net/appdl/runway.exe' -OutFile .\runway.exe
    $outFolder = '.\out'
    if (-not (Test-Path $outFolder)) {
        New-Item $outFolder -ItemType Directory
    }
    .\runway -N -S $settings.host download --directory $outFolder
    # djoin
    $zips = Get-ChildItem $outFolder\*.zip
    if($zips.Count -gt 1) {
        Write-Host 'Too many zips.'
    } else {
        Expand-Archive $zips[0].FullName -DestinationPath $outFolder

        Get-ChildItem $outFolder -Recurse
        
        $file = Get-ChildItem $outFolder -Recurse -Filter *.req

        Get-ChildItem .\results -Recurse | Remove-Item -Force -Confirm:$false

        certreq -submit -attrib "CertificateTemplate:$($settings.'Certificate Template')" -config SubCA1.runway.lab\LabSubCA1 $($file.FullName) .\results\cert.cer .\results\cert.pfx
    }
} else {
    Write-host 'Action will not work on a non-CA runner.'
}
# debug
Copy-Item .\std.out -Destination .\results