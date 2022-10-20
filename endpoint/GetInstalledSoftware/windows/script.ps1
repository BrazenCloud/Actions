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

$cuHive = [Microsoft.Win32.RegistryHive]::CurrentUser
$lmHive = [Microsoft.Win32.RegistryHive]::LocalMachine

foreach ($cn in ($computerNames | Select-Object -Unique)) {
    # Script
    $searchKeys = "Software\Microsoft\Windows\CurrentVersion\Uninstall", "SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall"
    $hives = @{}
    if ($cn -eq $env:COMPUTERNAME) {
        $hives['CurrentUser'] = [Microsoft.Win32.RegistryKey]::OpenBaseKey($cuHive, [Microsoft.Win32.RegistryView]::Default)
        $hives['LocalMachine'] = [Microsoft.Win32.RegistryKey]::OpenBaseKey($lmHive, [Microsoft.Win32.RegistryView]::Default)
    } else {
        if (!(Test-Connection -ComputerName $cn -Count 1 -Quiet)) {
            Write-Error -Message "Unable to contact $cn. Please verify its network connectivity and try again." -Category ObjectNotFound -TargetObject $cn
            Break
        }
        $hives['LocalMachine'] = [Microsoft.Win32.RegistryKey]::OpenRemoteBaseKey($lmHive, $cn)
        $hives['CurrentUser'] = [Microsoft.Win32.RegistryKey]::OpenRemoteBaseKey($cuHive, $cn)
    }
    $masterKeys = & {
        foreach ($key in $searchKeys) {
            foreach ($hive in $hives.Keys) {
                $regKey = $hives[$hive].OpenSubkey($key)
                if ($regKey -ne $null) {
                    foreach ($subName in $regKey.GetSubkeyNames()) {
                        foreach ($sub in $regKey.OpenSubkey($subName)) {
                            [pscustomobject]@{
                                "Name"             = $sub.GetValue("displayname")
                                "SystemComponent"  = $sub.GetValue("systemcomponent")
                                "ParentKeyName"    = $sub.GetValue("parentkeyname")
                                "Version"          = $sub.GetValue("DisplayVersion")
                                "UninstallCommand" = $sub.GetValue("UninstallString")
                                "InstallDate"      = $sub.GetValue("InstallDate")
                                "RegPath"          = $sub.ToString()
                                "ComputerName"     = $env:computername
                            }
                        }
                    }
                }
            }
        }
    }
    $woFilter = { $null -ne $_.name -AND $_.SystemComponent -ne "1" -AND $null -eq $_.ParentKeyName }
    $props = 'Name', 'Version', 'ComputerName', 'Installdate', 'UninstallCommand', 'RegPath'
    $masterKeys = ($masterKeys | Where-Object $woFilter | Select-Object $props | Sort-Object Name)

    # Output to .\results
    switch ($outputType) {
        'csv' { $masterKeys | Export-Csv ".\results\$cn-installedsw.csv" -Encoding UTF8 }
        'json' { $masterKeys | ConvertTo-Json -Depth 3 | Out-File ".\results\$cn-installedsw.json" -Encoding UTF8 }
    }
}