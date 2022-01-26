$cdir = Get-Item .\cdir-collector.exe

$process = Start-Process $cdir.FullName -RedirectStandardError .\stderr.txt -RedirectStandardOutput .\stdout.txt -PassThru

$stringToFind = 'Press Enter key to continue...'

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