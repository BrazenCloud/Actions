$settings = Get-Content .\settings.json | ConvertFrom-Json
$settings

Write-Host 'Event log start...'

$logNameTemplate = @'
  - name: {logname}
    ignore_older: {timeinminutes}
    no_more_events: {nomoreevents}
'@

$defaultLogNames = @'
  - name: Application
    ignore_older: 72h

  - name: System

  - name: Security

  - name: Microsoft-Windows-Sysmon/Operational

  - name: Windows PowerShell
    event_id: 400, 403, 600, 800

  - name: Microsoft-Windows-PowerShell/Operational
    event_id: 4103, 4104, 4105, 4106

  - name: ForwardedEvents
    tags: [forwarded]
'@

$output = @{
    File    = @'
output.file:
  enabled: true
  codec.json:
    pretty: false
  path: {path}
  filename: winlogbeat
  number_of_files: 10
'@
    Stream  = @'
output.console:
  enabled: true
  codec.json:
    pretty: false
'@
    Elastic = @'
output.elasticsearch:
    enabled: true
    protocol: "https"
    pipeline: "winlogbeat-%{[agent.version]}-routing"
    hosts: {hosts}
    protocol: "https"
    #api_key: {apikey}
    username: {username}
    password: {password}
    ssl.enabled: true
    ssl.verification_mode: none
'@
}

$ymlContent = Get-Content '.\windows\winlogbeat2\templateWinLogBeat.yml' -Raw

if ($settings.'Event Log Names' -eq 'default') {
    Write-Host 'Using default event log settings.'
    $replaceLogName = $defaultLogNames
}

if ([int]$settings.'Tail Time in Minutes' -gt 0 -and $settings.'Event Log Names' -ne 'default') {
    # adjust ignore_older
    Write-Host "Retrieving the previous $($settings.'Tail Time in Minutes') minutes logs from the $($settings.'Event Log Names') log(s)."

    $replaceLogName = foreach ($logname in $settings.'Event Log Names' -split ',') {
        ($logNameTemplate -replace '\{logname\}', $logname) `
            -replace '\{timeinminutes\}', "$($settings.'Tail Time in Minutes')m"
    }
}

$ymlContent = $ymlContent -replace '\{logname\}', ($replaceLogName -join "`n")

if ([int]$settings.'Wait Time in Minutes' -gt 0) {
    $ymlContent = $ymlContent -replace '\{nomoreevents\}', ''
} else {
    $ymlContent = $ymlContent -replace '\{nomoreevents\}', 'stop'
}

$resultsFolder = (Get-Item .\results).FullName

if ($settings.Stream.ToString() -eq 'true') {
    $ymlContent = $ymlContent -replace '\{output\}', $output['Elastic'] `
        -replace '\{username\}', "`"$($settings.'Elastic User Name')`"" `
        -replace '\{password\}', "`"$($settings.'Elastic User Password')`"" `
        -replace '\{hosts\}', "[`"$($settings.'Elastic Url')`"]"
} else {
    $fileOutput = $output['File'] -replace '\{path\}', $resultsFolder
    $ymlContent = $ymlContent -replace '\{output\}', $fileOutput
}

$ymlContent | Out-File .\windows\winlogbeat2\winlogbeat.yml
$ymlContent | Out-File .\results\winlogbeat.yml

if ($settings.Stream.ToString() -eq 'true') {
    $command = "Start-Sleep -Seconds 15;.\winlogbeat.exe --path.logs '$resultsFolder\logs'"
    $encodedCommand = [System.Convert]::ToBase64String([System.Text.Encoding]::Unicode.GetBytes($command))
    $procSplat = @{
        WorkingDirectory       = "$PSScriptRoot\winlogbeat2"
        FilePath               = 'powershell.exe'
        ArgumentList           = "-ExecutionPolicy Bypass -encodedCommand $encodedCommand"
        RedirectStandardOutput = "$resultsFolder\connectstdout.txt"
        RedirectStandardError  = "$resultsFolder\connectstderr.txt"
    }
    Start-Process @procSplat

    $rw = '.\windows\runway.exe'
    $command = "$rw -N -S $($settings.host) stream --connect $($settings.'Stream Name') --input tcp://localhost:9200 --persistent"
    Write-Host $command
    Invoke-Command -ScriptBlock ([scriptblock]::Create($command)) -NoNewScope
} else {
    Set-Location $PSScriptRoot\winlogbeat2
    .\winlogbeat.exe --path.logs "$resultsFolder\logs"
    Set-Location ..\..
}