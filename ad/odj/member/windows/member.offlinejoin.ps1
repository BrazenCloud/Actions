# Check to be sure we aren't on a Domain Controller
# Using Get-WmiObject for backwards compat
# Info: https://docs.microsoft.com/en-us/windows/win32/cimwin32prov/win32-operatingsystem
if ((Get-WmiObject Win32_OperatingSystem).ProductType -ne 2) {
    # Load settings
    $settings = Get-Content .\settings.json | ConvertFrom-Json
    $settings
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
        
        $file = Get-ChildItem $outFolder -Recurse | ?{$_.Name -eq 'blob.txt'}

        djoin /requestodj /loadfile $($file.FullName) /windowspath c:\windows /localos
    }
} else {
    Write-Host 'This is a DC. That is bad.'
}
# debug
Copy-Item .\std.out -Destination .\results