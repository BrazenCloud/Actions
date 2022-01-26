# Build the INI
$settings = Get-Content .\settings.json | ConvertFrom-Json
$settings

$cdirIni = @{
    Output = '\results'
}
$params = 'MemoryDump','MFT','Secure','UsnJrnl','EventLog','Prefetch','Registry','WMI','SRUM','Web','Target','MemoryDumpCmdline'
foreach ($param in $params){
    $cdirIni[$param] = $settings.$param
}
foreach ($key in $cdirIni.Keys) {
    "$key = $($cdirIni[$key])`n" | Out-File .\cdir.ini -Append
}

# Run the CDIR utility
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