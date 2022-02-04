$settings = Get-Content .\settings.json | ConvertFrom-Json
$settings

$folders = Get-ChildItem .\windows -Directory

$order = 'Complete','Memory Dump','Triage'

:order foreach ($script in $order) {
    if ($settings.$script -eq $true) {
        break order
    }
}

if ($settings.Secure -eq $true) {
    $script = "Secure-$script"
}

$path = ".\windows\scripts\$($script.Replace(' ','_'))_Windows_Live_Response.bat"
$path
if (Test-Path $path) {
    & $path
} else {
    Write-Host 'No Path.'
}

Get-ChildItem .\windows -Directory | Where-Object {$folders.Name -notcontains $_.Name} | ForEach-Object {
    Move-Item $_.FullName -Destination .\results
}