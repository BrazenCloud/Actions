$settings = Get-Content .\settings.json | ConvertFrom-Json
# Get Settings
$supportedTypes = 'csv', 'json'
$settings = Get-Content .\settings.json | ConvertFrom-Json
if ($supportedTypes -notcontains $settings.'Output Type'.ToLower()) {
    $outputType = 'csv'
} else {
    $outputType = $settings.'Output Type'
}

$computerNames = & {
    if ($settings.'Computer Name'.Length -gt 0) {
        $settings.'Computer Name'.Split(',') | ForEach-Object { $_.Trim() }
    }
    $env:COMPUTERNAME
}

foreach ($cn in ($computerNames | Select-Object -Unique)) {
    # Script
    $searchKeys = "Software\Microsoft\Windows\CurrentVersion\Uninstall", "SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall"
    $hives = @{}
    $services = if ($cn -eq $env:COMPUTERNAME) {
        Get-Service
    } else {
        if (!(Test-Connection -ComputerName $cn -Count 1 -Quiet)) {
            Write-Error -Message "Unable to contact $cn. Please verify its network connectivity and try again." -Category ObjectNotFound -TargetObject $cn
            Break
        }
        Get-Service -ComputerName $cn
    }

    if ($settings.'Add computer name to output'.ToString() -eq 'true') {
        $services = $services | Select-Object *, @{Name = 'ComputerName'; Expression = { $cn } }
    }

    # Output to .\results
    switch ($outputType) {
        'csv' { $services | Export-Csv ".\results\$cn-services.csv" -NoTypeInformation -Encoding UTF8 }
        'json' { $services | ConvertTo-Json -Depth 3 | Out-File ".\results\$cn-services.json" -Encoding UTF8 }
    }
}