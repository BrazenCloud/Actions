$settings = Get-Content .\settings.json | ConvertFrom-Json
$settings

if ($settings.'Input Type'.ToLower() -match 'tcp|pipe|file') {
    $rw = '.\windows\runway.exe'
    $commandString = "-N stream --listen $($settings.'Stream Name') --input $($settings.'Input Type')://$($settings.Address)"
    if ($settings.TimeOut) {
        $commandString += " --timeout $($settings.TimeOut)"
    }
    Write-Host "$rw $commandString"

    & $rw who

    Invoke-Command -ScriptBlock ([scriptblock]::Create("$rw $commandString"))
}