$settings = Get-Content .\settings.json | ConvertFrom-Json

if ([int]$settings.'Tail Count' -gt 0) {
    Write-Host "Retrieving the previous $($settings.'Tail Count') logs from the $($settings.'Event Log Name') log."
    
    # Get 'Tail Count' number of events and output to results floder
    $eSplat = @{
        LogName   = $settings.'Event Log Name'
        MaxEvents = $settings.'Tail Count'
    }
    if ($settings.'XPath Query'.Length -gt 0) {
        $eSplat['FilterXPath'] = $settings.'XPath Query'
    }
    Get-WinEvent @eSplat | ConvertTo-Json -Depth 5 | Out-File ".\results\$($env:COMPUTERNAME)_$(Get-Date -UFormat %s)_events.json"
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