$settings = Get-Content .\settings.json | ConvertFrom-Json
$settings

<#$setti ngs = [pscustomobject]@{
    'Output Type' = 'tcp'
    'Stream Name' = 'new-ssh-stream'
    Address = '10.0.0.24:22'
    TimeOut = '15m'
}#>

if ($settings.'Output Type'.ToLower() -match 'tcp|pipe|file') {
    $rw = '.\windows\runway.exe'
    $commandString = "-N -S $($settings.host) stream --connect $($settings.'Stream Name') --output $($settings.'Output Type')://$($settings.Address)"
    if ($settings.TimeOut) {
        $commandString += " --timeout $($settings.TimeOut)"
    }
    Write-Host "$rw $commandString"
    #Start-Process -FilePath $rw -ArgumentList $commandString -Wait
    Invoke-Command -ScriptBlock ([scriptblock]::Create("$rw $commandString"))

    #.\windows\runway.exe -N stream --connect new-ssh-stream --output tcp://10.0.0.24:22 --timeout 15m
}