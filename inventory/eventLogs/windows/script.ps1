#$settings = Get-Content .\settings.json | ConvertFrom-Json

$logNameTemplate = @'
  - name: {logname}
    ignore_older: {timeinminutes}m
    no_more_events: {nomoreevents}
'@

$logNameTemplate = if ($settings.Stream.ToString() -eq 'true') {
    $logNameTemplate -replace '\{nomoreevents\}', 'stop'
} else {
    $logNameTemplate -replace '\{nomoreevents\}', 'stop'
}

$output = @{
    File   = @'
output.file:
  enabled: true
  codec.json:
    pretty: false
  path: {path}
  filename: winlogbeat
  number_of_files: 2
'@
    Stream = @'
output.console:
  enabled: true
  codec.json:
    pretty: false
'@
}

$ymlContent = Get-Content '.\windows\winlogbeat\templateWinLogBeat.yml' -Raw

if ([int]$settings.'Tail Time in Minutes' -gt 0) {
    Write-Host "Retrieving the previous $($settings.'Tail Time in Minutes') minutes logs from the $($settings.'Event Log Name') log(s)."

    $replaceLogName = foreach ($logname in $settings.'Event Log Name' -split ',') {
        ($logNameTemplate -replace '\{logname\}', $logname) -replace '\{timeinminutes\}', $settings.'Tail Time in Minutes'
        
    }

    $ymlContent = $ymlContent -replace '\{logname\}', ($replaceLogName -join "`n")
    
    # if stream, output to console. Else output to file
    if ($settings.Stream.ToString() -eq 'true') {
        # Set the winlogbeat config to output to console
        $ymlContent = $ymlContent -replace '\{output\}', $output['Stream']
        $ymlContent | Out-File .\windows\winlogbeat\winlogbeat.yml

        # Stream the output
        $rw = '..\stagingrunway.exe'
        $commandString = "-N -S $($settings.host) stream --connect $($settings.'Stream Name') --input pipe://stdin"
        Write-Host "$rw $commandString"
        $resultsFolder = (Get-Item .\results).FullName
        Set-Location $PSScriptRoot\winlogbeat
        Invoke-Command -ScriptBlock ([scriptblock]::Create(".\winlogbeat.exe --path.logs $resultsFolder\logs | %{`$_.ToString()} | $rw $commandString"))
        Set-Location ..\..
    } else {
        $resultsFolder = (Get-Item .\results).FullName
        $fileOutput = $output['File'] -replace '\{path\}', $resultsFolder
        $ymlContent = $ymlContent -replace '\{output\}', $fileOutput
        $ymlContent | Out-File .\windows\winlogbeat\winlogbeat.yml
        Set-Location $PSScriptRoot\winlogbeat
        .\winlogbeat.exe --path.logs "$resultsFolder\logs"
        Set-Location ..\..
    }
} elseif ([int]$settings.'Wait Time in Minutes' -gt 0) {
    Write-Host "Streaming the logs from the $($settings.'Event Log Name') log for $($settings.'Wait Time in Minutes')."

    # Create a listener to listen for 'Wait Time in Minutes' minutes
    $global:Events = [System.Collections.Generic.List[System.Diagnostics.Eventing.Reader.EventLogRecord]]::new()
    $logName = $settings.'Event Log Name'
    if ($settings.'XPath Query'.Length -gt 0) {
        $select = $settings.'XPath Query'
    } else {
        $select = "*"
    }
    $query = [System.Diagnostics.Eventing.Reader.EventLogQuery]::new($logName, [System.Diagnostics.Eventing.Reader.PathType]::LogName, $select)
    $watcher = [System.Diagnostics.Eventing.Reader.EventLogWatcher]::new($query)
    $watcher.Enabled = $true
    $action = {
        $global:Events.Add($eventArgs.EventRecord)
    }
    $job = Register-ObjectEvent -InputObject $watcher -EventName 'EventRecordWritten' -Action $action
    Receive-Job $job

    # Wait for the specified number of minutes
    Start-Sleep -Seconds (60 * [int]$settings.'Wait Time in Minutes')

    # Output to results folder
    $Events | ConvertTo-Json | Out-File ".\results\$($env:COMPUTERNAME)_$(Get-Date -UFormat %s)_events.json"
}