# Move stuff out of the Windows folder
Get-ChildItem .\Windows | ForEach-Object {
    Move-Item $_.FullName -Destination .\
}

# Create a temp folder
$tempFolder = "$($env:TEMP)\cdir_$(Get-Date -format yyyyMMdd-hhmmss)"
if (-not (Test-Path $tempFolder)) {
    New-Item $tempFolder -ItemType Directory
}

# Build the INI
$settings = Get-Content .\settings.json | ConvertFrom-Json
$settings

$cdirIni = @{
    Output = $tempFolder
}
$params = 'MemoryDump','MFT','Secure','UsnJrnl','EventLog','Prefetch','Registry','WMI','SRUM','Web','Target','MemoryDumpCmdline'
foreach ($param in $params){
    $cdirIni[$param] = $settings.$param
}
$outStr = foreach ($key in $cdirIni.Keys) {
    "$key = $($cdirIni[$key])"
}
[System.IO.File]::WriteAllLines("$((Get-Location).Path)\cdir.ini", $outStr)

# Run the CDIR utility
$cdir = Get-Item .\cdir-collector.exe

$process = Start-Process $cdir.FullName -RedirectStandardError .\stderr.txt -RedirectStandardOutput .\stdout.txt -PassThru

$stringToFind = 'Press Enter key to continue...'

if (Test-Path .\stderr.txt) {
    $waiting = $true
    while ($waiting) {
        Start-Sleep -Seconds 10
        if ((Get-Content .\stderr.txt) -like "*$stringToFind") {
            Get-Content .\stderr.txt
            Get-Process 'cdir-collector' -ErrorAction SilentlyContinue | Stop-Process
            $waiting = $false
        }
    }
} else {
    Write-Host 'No file created. Error suspected.'
}

Get-ChildItem $tempFolder | Move-Item -Destination .\results
Remove-Item $tempFolder -Recurse -Force