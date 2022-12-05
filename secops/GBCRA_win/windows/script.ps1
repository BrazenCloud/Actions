# https://github.com/forgepoint/Audit/blob/master/GBCBA_Win.ps1
# Cyber Breach Assessment (CBA) - Copyright @2020 All Rights Reserved
# Updated by Shane Shook version="20201208" 
# Runas:  PowerShell.exe -ExecutionPolicy bypass -WindowStyle hidden -File (path to script) 

# This script produces useful information to identify Hosts of Interest for examination after suspected breach.
# Match SHA1 signatures of binaries, DNS addresses, or IP addresses to known bad or suspicious threat information.
# Correlate low frequency process commands to suspicious activities; and improper users by host to activities.

#Clear-Host
$localpath = "C:\secaudit" # This is the location where the output files will drop at runtime
$outpath = "c:\windows\temp"

$logtime = (Get-Date -UFormat %s)

# PREPARATION
Invoke-Command { mkdir $localpath } -ErrorVariable errmsg 2>$null
$ErrorActionPreference = 'SilentlyContinue'

$auditDate = Get-Date -UFormat %s

# build caches
$procHt = @{}
foreach ($proc in (Get-Process -IncludeUserName)) {
    $procHt[$proc.Id] = $proc
}
$servHt = @{}
foreach ($service in (Get-CimInstance -class win32_service)) {
    $servHt[$service.ProcessId] = $service
}


# NetProcMon
$WP = @{}
Get-WmiObject Win32_Process | ForEach-Object { $WP[$_.ProcessID] = $_ }
Get-NetTCPConnection |
    Select-Object -Property LocalAddress, LocalPort, RemoteAddress, RemotePort, State,
    @{Name = 'Computername'; Expression = { $env:COMPUTERNAME } }, 
    @{Name = 'AuditDate'; Expression = { $auditDate } }, 
    @{Name = 'PID'; Expression = { $_.OwningProcess } },
    @{Name = 'Process'; Expression = { ($procHt[$_.OwningProcess]).Name } },
    @{Name = 'UserName'; Expression = { ($procHt[$_.OwningProcess]).UserName } },
    @{Name = 'ServiceName'; Expression = { ($servHt[$_.OwningProcess]).Name } },
    @{Name = 'ServiceStartType'; Expression = { ($servHt[$_.OwningProcess]).StartMode } },
    @{Name = 'Path'; Expression = { ($procHt[$_.OwningProcess]).Path } }, 
    @{Name = 'SHA1'; Expression = { (Get-FileHash ($procHt[$_.OwningProcess]).Path -Algorithm SHA1 | Select-Object -ExpandProperty Hash) } },
    @{Name = 'CommandLine'; Expression = { $WP[[UInt32]$_.OwningProcess].CommandLine } }, 
    @{Name = 'Connected'; Expression = { (Get-Date -UFormat %s $_.CreationTime) } } |
        Select-Object Computername, AuditDate, UserName, PID, Process, ServiceName, Path, 
        ServiceStartType, SHA1, CommandLine, Connected, State, LocalAddress, LocalPort, RemoteAddress, RemotePort |
            Where-Object Process -NotLike 'Idle' | 
                Export-Csv -Path $localpath\"$env:computername"-activecomms.csv -Append -Encoding UTF8 -NoTypeInformation $ErrorActionPreference
	
# ServiceBinaries
Get-Service | ForEach-Object {
    $binaryPath = $_.BinaryPathName
    if (-not $binaryPath) {
        $binaryPath = try { Get-ItemPropertyValue -EA Ignore "HKLM:\SYSTEM\CurrentControlSet\Services\$($_.Name)" ImagePath } catch { }
    }
    if ($binaryPath -like '*\svchost.exe *') {
        foreach ($keyName in $_.Name, ($_.Name -split '_')[0]) {
            foreach ($subKeyName in "$keyName\Parameters", $keyName) {
                $binaryPath = try { Get-ItemPropertyValue -EA Ignore "HKLM:\SYSTEM\CurrentControlSet\Services\$subKeyName" ServiceDLL } catch { }
                if ($binaryPath) { break }
            }
        }
    }
    $binaryPath = if ($binaryPath -like '"*') {
      ($binaryPath -split '"')[1]
    } else {
      (-split $binaryPath)[0]
    }
    $FileVersionInfo = if ($binaryPath) { (Get-Item -LiteralPath $binaryPath).VersionInfo }
    [pscustomobject] @{
        Name            = $_.Name
        BinaryPath      = if ($binaryPath) { $binaryPath } else { '(n/a)'; Write-Error "Failed to determine binary path for service '$($_.Name)'. Try running as admin." }
        ProductName     = $FileVersionInfo.ProductName
        FileDescription = $FileVersionInfo.FileDescription
        CompanyName     = $FileVersionInfo.CompanyName
        FileVersion     = $FileVersionInfo.FileVersion
        ProductVersion  = $FileVersionInfo.ProductVersion
        SHA1            = (Get-FileHash $binaryPath -Algorithm SHA1 | Select-Object -ExpandProperty Hash)
    }
} |
    Select-Object @{Name = 'Computername'; Expression = { $env:COMPUTERNAME } }, 
    @{Name = 'AuditDate'; Expression = { Get-Date -UFormat %s } }, 
    Name, BinaryPath, ProductName, FileDescription, CompanyName, FileVersion, ProductVersion, Sha1 | 
        Export-Csv -Path $localpath\"$env:computername"-servicebinaries.csv -Append -Encoding UTF8 -NoTypeInformation $ErrorActionPreference

# NICSettings
Get-WmiObject -Class Win32_NetworkAdapterConfiguration | 
    Select-Object @{Label = "Computername"; Expression = { $_.__SERVER } }, 
    @{Name = 'AuditDate'; Expression = { Get-Date -UFormat %s } }, 
    description, 
    macaddress, 
    @{Label = "IPaddress"; Expression = { $_.ipaddress | Select-Object -First 1 } }, 
    @{Label = "IPsubnet"; Expression = { $_.ipsubnet } }, 
    @{Label = "DefaultIPGateway"; Expression = { $_.defaultipgateway } }, 
    dhcpenabled, 
    @{Label = "DHCPserver"; Expression = { $_.dhcpserver } }, 
    @{Label = "DNSServer"; Expression = { $_.DNSServerSearchOrder } } | 
        Export-Csv -Path $localpath\"$env:computername"-nic.csv -Encoding UTF8 -NoTypeInformation 
	
# DNSCache
Invoke-Command -ScriptBlock {
    ipconfig /displaydns | 
        Select-Object -Unique @{Name = 'Computername'; Expression = { $env:COMPUTERNAME } }, 
        @{Name = 'AuditDate'; Expression = { Get-Date -UFormat %s } }, 
        @{Name = 'dns'; Expression = { $_.ToString().Split(' ')[-1] } } | 
            Where-Object { $_.dns -like "*.*" }
        } | 
            Export-Csv -Path $localpath\"$env:computername"-dnscache.csv -Encoding UTF8 -NoTypeInformation

# OSInfo
Get-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion" | 
    Select-Object @{Name = 'Computername'; Expression = { $env:COMPUTERNAME } },
    @{Name = 'AuditDate'; Expression = { Get-Date -UFormat %s } }, 
    ProductName, 
    CSDVersion, 
    CurrentVersion, 
    CurrentBuild, 
    BuildLabEx |
        Export-Csv -Path $localpath\"$env:computername"-osinfo.csv -Encoding UTF8 -NoTypeInformation

# Missing Windows Patches
$Patches = @(
    $MUS = New-Object -com Microsoft.Update.Session
    $Usearch = $MUS.CreateUpdateSearcher()
    $Usresult = $Usearch.Search("IsInstalled=0 and Type='Software'")
    ForEach ($update in $Usresult.Updates) {
        $update | Select-Object @{Name = 'Computername'; Expression = { $env:COMPUTERNAME } },
        @{Name = 'AuditDate'; Expression = { Get-Date -UFormat %s } },
        @{Name = 'Patch'; Expression = { $Update.Title } }
    }
    $ErrorActionPreference )  
$Patches | ConvertTo-Csv -NoTypeInformation |
    Out-File $localpath\"$env:computername"-missingpatches.csv -Encoding UTF8

# LOCALUsersGroups
$adsi = [ADSI]"WinNT://$env:COMPUTERNAME"
$adsi.Children | Where-Object { $_.SchemaClassName -eq 'user' } | ForEach-Object {
    $groups = $_.Groups() | ForEach-Object {
        $_.GetType().InvokeMember('Name', 'GetProperty', $null, $_, $null)
    }
    $_ | Select-Object @{Name = 'Computername'; Expression = { $env:COMPUTERNAME } },
    @{Name = 'AuditDate'; Expression = { Get-Date -UFormat %s } },
    @{n = 'UserName'; e = { $_.Name } },
    @{n = 'LastLogin'; e = { $_.LastLogin | Get-Date -UFormat %s } }, 
    @{name = "Enabled"; Expression = {
            if ($_.psbase.properties.item("userflags").value -band $ADS_UF_ACCOUNTDISABLE) {
                $False 
            } else { $True } }
    },
    @{n = 'Groups'; e = { $groups -join ';' } }
} | Export-Csv -Path $localpath\"$env:computername"-localusergroups.csv -Encoding UTF8 -NoTypeInformation $ErrorActionPreference

# ProfileSIDs
Get-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\ProfileList\*" |
    Select-Object @{Name = 'Computername'; Expression = { $env:COMPUTERNAME } },
    @{Name = 'AuditDate'; Expression = { Get-Date -UFormat %s } }, 
    @{Name = 'UserSID'; Expression = { $_.PSChildName } },
    ProfileImagePath | 
        Export-Csv -Path $localpath\"$env:computername"-profilesids.csv -Encoding UTF8 -NoTypeInformation $ErrorActionPreference 

# SCHEDULEDTasks
$sched = New-Object -Com "Schedule.Service"
$sched.Connect()
$out = @()
$sched.GetFolder("\").GetTasks(0) | ForEach-Object {
    $xml = [xml]$_.xml
    $out += New-Object psobject -Property @{
        "ComputerName" = $env:COMPUTERNAME 
        "Name"         = $_.Name
        "Status"       = switch ($_.State) { 0 { "Unknown" } 1 { "Disabled" } 2 { "Queued" } 3 { "Ready" } 4 { "Running" } }
        "LastRunTime"  = $_.LastRunTime 
        "NextRunTime"  = $_.NextRunTime
        "Actions"      = ($xml.Task.Actions.Exec | ForEach-Object { "$($_.Command) $($_.Arguments)" }) -join "`n"
        "Enabled"      = $xml.task.settings.enabled
        "Author"       = $xml.task.principals.Principal.UserID
        "Description"  = $xml.task.registrationInfo.Description
        "RunAs"        = $xml.task.principals.principal.userid
        "Created"      = $xml.Task.RegistrationInfo.Date
    }
}
$out | 
    Select-Object Computername, 
    @{Name = 'AuditDate'; Expression = { Get-Date -UFormat %s } }, 
    Name, 
    Status, 
    @{ Label = "LastRunTime"; Expression = { $_.LastRunTime | Get-Date -UFormat %s } },
    @{ Label = "NextRunTime"; Expression = { $_.NextRunTime | Get-Date -UFormat %s } },
    Actions, 
    Enabled, 
    Author, 
    Description, 
    RunAs, 
    @{ Label = "Created"; Expression = { $_.Created | Get-Date -UFormat %s } } |
        Export-Csv -Path $localpath\"$env:computername"-tasks.csv -Encoding UTF8 -NoTypeInformation

## CLEANUP
# ZIP Results
$zip = $localpath + "\" + $env:Computername + "-" + $logtime + ".zip" 
New-Item $zip -ItemType file
$shellApplication = New-Object -com shell.application
$zipPackage = $shellApplication.NameSpace($zip)
$files = Get-ChildItem -Path $localpath\* -Exclude "*.zip" -Recurse
Start-Sleep -Milliseconds 1000
foreach ($file in $files) { 
    $zipPackage.CopyHere($file.FullName)
    Start-Sleep -Milliseconds 1000
}
Start-Sleep -Milliseconds 1000
# MOVE zip file to the network share
Move-Item $localpath\*.zip $outpath -Force
# REMOVE Files and Folder
Remove-Item $localpath -Recurse -Force

# End of CBA Script