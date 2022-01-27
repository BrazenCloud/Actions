# Move stuff out of the Windows folder
Get-ChildItem .\Windows | ForEach-Object {
    Move-Item $_.FullName -Destination .\
}

# Create a temp folder
$tempFolder = "C:\TEMP\cdir_$(Get-Date -format yyyyMMdd-hhmmss)"
if (-not (Test-Path $tempFolder)) {
    New-Item $tempFolder -ItemType Directory -Force
}

# Update INI to use the temp folder path
$ini = Get-Content .\cdir.ini
$ini = $ini | ?{$_ -notlike 'Output*'}
$ini += "Output = $($tempFolder)"
[System.IO.File]::WriteAllLines("$((Get-Location).Path)\cdir.ini", $ini)

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