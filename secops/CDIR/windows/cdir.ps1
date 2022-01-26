# Move stuff out of the Windows folder
Get-ChildItem .\Windows | ForEach-Object {
    Move-Item $_.FullName -Destination .\
}

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
    Write-Host 'Done!'
} else {
    Write-Host 'No file created. Error suspected.'
}