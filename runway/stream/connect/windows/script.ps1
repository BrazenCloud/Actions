$settings = Get-Content .\settings.json | ConvertFrom-Json
$settings

if ($settings.'Output Type'.ToLower() -match 'tcp|pipe|file') {
    $rw = '.\windows\runway.exe'
    $commandString = "-N -S $($settings.host) stream --connect $($settings.'Stream Name') --output $($settings.'Output Type')://$($settings.Address)"
    if ($settings.TimeOut) {
        $commandString += " --timeout $($settings.TimeOut)"
    }
    Write-Host "$rw $commandString"
    Invoke-Command -ScriptBlock ([scriptblock]::Create("$rw $commandString"))
}