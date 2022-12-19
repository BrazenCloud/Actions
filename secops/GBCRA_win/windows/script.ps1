# https://github.com/forgepoint/Audit/blob/master/GBCRA_Win.ps1
# Cyber Compromise Audit (CRA) FULL - Copyright @2017 All Rights Reserved
# Updated by Shane Shook 
$version = "20200902" 
# Runas:  PowerShell.exe -ExecutionPolicy bypass -WindowStyle hidden -File (path to script) 

#Clear-Host
# Variables declared here - adjust to suit the environment
$localpath = ".\results" # This is the location where the output files will drop at runtime

# This is the network share where the script will drop off the zip files
#$networkshare = "\\ADDC\CRA\" 
#$outputfile = "\\ADDC\CRA\$env:computername*.zip"

# To use local storage on host just comment out the above two lines and uncomment the following two
#$networkshare = ".\results"
#$outputfile = ".\results\$env:computername*.zip"

$logtime = (Get-Date -UFormat %s)
#$logtime = (Get-Date)
$myFQDN = (Get-WmiObject win32_computersystem).DNSHostName + "." + (Get-WmiObject win32_computersystem).Domain
$ErrorActionPreference = 'SilentlyContinue'


# Check if marker file exists, used to control script execution when linked to GPO/Login 
#If (-Not (Test-Path $outputfile.trim() )) {

# PREPARATION

Invoke-Command { mkdir $localpath } -ErrorVariable errmsg 2>$null

## USERS

# 1) LOCAL Users and Groups
$ErrorActionPreference = 'SilentlyContinue'
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
} | Export-Csv -Path $localpath\"$env:computername"-allusers.csv -Encoding UTF8 -NoTypeInformation
Start-Sleep -Milliseconds 1000

# 2) LOCAL Users found in the registry
Get-WmiObject win32_useraccount -Filter "Localaccount='True'" | 
    Select-Object @{Name = 'Computername'; Expression = { $env:COMPUTERNAME } },
    @{Name = 'AuditDate'; Expression = { Get-Date -UFormat %s } },
    AccountType,
    Caption,
    Domain,
    SID,
    FullName,
    Name |
        Export-Csv -Path $localpath\"$env:computername"-allusers_reg.csv -Encoding UTF8 -NoTypeInformation


# 3) LOCAL Profiles
$ErrorActionPreference = 'SilentlyContinue'
Get-ChildItem 'HKLM:\Software\Microsoft\Windows NT\CurrentVersion\ProfileList' | 
    ForEach-Object {      
        $profilePath = $_.GetValue('ProfileImagePath')    
        Get-ChildItem -Path "$profilePath\*" -Force -Include NTUSER.DAT -ErrorAction "SilentlyContinue" } | 
        Select-Object @{Name = 'Computername'; Expression = { $env:COMPUTERNAME } }, 
        @{Name = 'AuditDate'; Expression = { Get-Date -UFormat %s } }, 
        Name, 
        Length, 
        DirectoryName, 
        @{ Label = "CreationTime"; Expression = { $_.CreationTime | Get-Date -UFormat %s } }, 
        @{ Label = "LastWriteTime"; Expression = { $_.LastWriteTime | Get-Date -UFormat %s } },
        @{ Label = "ProductVersion"; Expression = { $_.VersionInfo.ProductVersion } }, 
        @{ Label = "FileVersion"; Expression = { $_.VersionInfo.FileVersion } }, 
        @{ Label = "Description"; Expression = { $_.VersionInfo.FileDescription } } |
            ConvertTo-Csv -NoTypeInformation |
                Out-File -Append $localpath\"$env:computername"-allprofiles.csv -Encoding UTF8 
Start-Sleep -Milliseconds 1000


# 4) LOCAL Profiles found in the registry
$ErrorActionPreference = 'SilentlyContinue'
Get-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\ProfileList\*" |
    Select-Object @{Name = 'Computername'; Expression = { $env:COMPUTERNAME } },
    @{Name = 'AuditDate'; Expression = { Get-Date -UFormat %s } }, 
    Sid,
    PSChildName,
    ProfileImagePath |
        Export-Csv -Path $localpath\"$env:computername"-allprofiles_reg.csv -Encoding UTF8 -NoTypeInformation

## OPERATING SYSTEM

# 5) OperatingSystem Build Info 
$ErrorActionPreference = 'SilentlyContinue'
Get-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion" | 
    Select-Object @{Name = 'Computername'; Expression = { $env:COMPUTERNAME } },
    @{Name = 'AuditDate'; Expression = { Get-Date -UFormat %s } }, 
    ProductName, 
    CSDVersion, 
    CurrentVersion, 
    CurrentBuild, 
    BuildLabEx |
        Export-Csv -Path $localpath\"$env:computername"-osinfo.csv -Encoding UTF8 -NoTypeInformation


## NETWORK

# 6) NIC Settings
$ErrorActionPreference = 'SilentlyContinue'
Get-WmiObject -Class Win32_NetworkAdapterConfiguration | 
    Select-Object @{Label = "Computer Name"; Expression = { $_.__SERVER } }, 
    @{Name = 'AuditDate'; Expression = { Get-Date -UFormat %s } }, 
    description, 
    macaddress, 
    @{Label = "IPaddress"; Expression = { $_.ipaddress | Select-Object -First 1 } }, 
    @{Label = "IPsubnet"; Expression = { $_.ipsubnet } }, 
    @{Label = "DefaultIPGateway"; Expression = { $_.defaultipgateway } }, 
    dhcpenabled, 
    @{Label = "DHCPserver"; Expression = { $_.dhcpserver } }, 
    @{Label = "DNS Server"; Expression = { $_.DNSServerSearchOrder } } | 
        Export-Csv -Path $localpath\"$env:computername"-nic.csv -Encoding UTF8 -NoTypeInformation

# 7) OPEN Ports
$ErrorActionPreference = 'SilentlyContinue'
Invoke-Command -ScriptBlock {
    $null, $null, $null, $null, $netstat = netstat -a -n -o
    [regex]$regexTCP = '(?<Protocol>\S+)\s+((?<LAddress>(2[0-4]\d| 
25[0-5]|[01]?\d\d?)\.(2[0-4]\d|25[0-5]|[01]?\d\d?)\.(2[0-4]\d| 
25[0-5]|[01]?\d\d?)\.(2[0-4]\d|25[0-5]|[01]?\d\d?))| 
(?<LAddress>\[?[0-9a-fA-f]{0,4}(\:([0-9a-fA-f]{0,4})){1,7}\%?\d?\]))\:(?<Lport>\d+)\s+((?<Raddress>(2[0-4]\d| 
25[0-5]|[01]?\d\d?)\.(2[0-4]\d|25[0-5]|[01]?\d\d?)\.(2[0-4]\d| 
25[0-5]|[01]?\d\d?)\.(2[0-4]\d|25[0-5]|[01]?\d\d?))| 
(?<RAddress>\[?[0-9a-fA-f]{0,4}(\:([0-9a-fA-f]{0,4})){1,7}\%?\d?\]))\:(?<RPort>\d+)\s+(?<State>\w+)\s+(?<PID>\d+$)'

    [regex]$regexUDP = '(?<Protocol>\S+)\s+((?<LAddress>(2[0-4]\d| 
25[0-5]|[01]?\d\d?)\.(2[0-4]\d|25[0-5]|[01]?\d\d?)\.(2[0-4]\d| 
25[0-5]|[01]?\d\d?)\.(2[0-4]\d|25[0-5]|[01]?\d\d?))| 
(?<LAddress>\[?[0-9a-fA-f]{0,4}(\:([0-9a-fA-f]{0,4})){1,7}\%?\d?\]))\:(?<Lport>\d+)\s+(?<RAddress>\*)\:(?<RPort>\*)\s+(?<PID>\d+)'

    [psobject]$process = "" | 
        Select-Object Protocol, 
        LocalAddress, 
        Localport, 
        RemoteAddress, 
        Remoteport, 
        State, 
        PID, 
        ProcessName

        foreach ($net in $netstat) {
            switch -regex ($net.Trim()) {
                $regexTCP {          
                    $process.Protocol = $matches.Protocol
                    $process.LocalAddress = $matches.LAddress
                    $process.Localport = $matches.LPort
                    $process.RemoteAddress = $matches.RAddress
                    $process.Remoteport = $matches.RPort
                    $process.State = $matches.State
                    $process.PID = $matches.PID
                    $process.ProcessName = ( Get-Process -Id $matches.PID ).ProcessName
                }
                $regexUDP {          
                    $process.Protocol = $matches.Protocol
                    $process.LocalAddress = $matches.LAddress
                    $process.Localport = $matches.LPort
                    $process.RemoteAddress = $matches.RAddress
                    $process.Remoteport = $matches.RPort
                    $process.State = $matches.State
                    $process.PID = $matches.PID
                    $process.ProcessName = ( Get-Process -Id $matches.PID ).ProcessName
                }
            }
            $process
        }
    } | 
        Select-Object @{Name = 'Computername'; Expression = { $env:COMPUTERNAME } }, 
        @{Name = 'AuditDate'; Expression = { Get-Date -UFormat %s } }, 
        Protocol, 
        LocalAddress, 
        LocalPort, 
        RemoteAddress, 
        Remoteport, 
        State, 
        PID, 
        ProcessName |
            Export-Csv -Path $localpath\"$env:computername"-netstat.csv -Encoding UTF8 -NoTypeInformation

# 8) DNS Cache
$ErrorActionPreference = 'SilentlyContinue'
Invoke-Command -ScriptBlock {
    ipconfig /displaydns | 
        Select-Object -Unique @{Name = 'Computername'; Expression = { $env:COMPUTERNAME } }, 
        @{Name = 'AuditDate'; Expression = { Get-Date -UFormat %s } }, 
        @{Name = 'dns'; Expression = { $_.ToString().Split(' ')[-1] } } | 
            Where-Object { $_.dns -like "*.*" }
        } | 
            Export-Csv -Path $localpath\"$env:computername"-dnscache.csv -Encoding UTF8 -NoTypeInformation


## PROCESSES

# 9) ACTIVE Processes
$ErrorActionPreference = 'SilentlyContinue'
gwmi win32_process | 
    Select-Object @{Name = 'Computername'; Expression = { $env:COMPUTERNAME } }, 
    @{Name = 'AuditDate'; Expression = { Get-Date -UFormat %s } }, 
    name, 
    processid, 
    path, 
    commandline | 
        Export-Csv -Path $localpath\"$env:computername"-processes.csv -Encoding UTF8 -NoTypeInformation

# 10) SCHEDULED Tasks
$ErrorActionPreference = 'SilentlyContinue'
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


## REGISTRY persistent services and startups

# 11) SERVICES with Image Paths
$ErrorActionPreference = 'SilentlyContinue'
Get-ItemProperty -Path HKLM:\SYSTEM\*\Services\* | 
    Select-Object @{Name = 'Computername'; Expression = { $env:COMPUTERNAME } },
    @{Name = 'AuditDate'; Expression = { Get-Date -UFormat %s } }, 
    @{Label = 'ControlSet'; Expression = { ($_.PSPath -split "\\")[-3] } }, 
    @{Label = 'ServiceName'; Expression = { ($_.PSPath -split "\\")[-1] } }, 
    @{Label = 'ImagePath'; Expression = { $_.ImagePath } } | 
        Export-Csv -Path $localpath\"$env:computername"-services.csv -Encoding UTF8 -NoTypeInformation

# 12) SERVICEDLLs with ControlSets
$ErrorActionPreference = 'SilentlyContinue'
Get-ItemProperty -Path HKLM:\SYSTEM\*\Services\*\Parameters | 
    Select-Object @{Name = 'Computername'; Expression = { $env:COMPUTERNAME } },
    @{Name = 'AuditDate'; Expression = { Get-Date -UFormat %s } }, 
    @{Label = 'ServiceName'; Expression = { ($_.PSPath -split "\\")[-2] } }, 
    @{Label = 'ControlSet'; Expression = { ($_.PSPath -split "\\")[-4] } }, 
    ServiceDll | 
        Where-Object { $_.ServiceDll -notlike '' } | 
            Export-Csv -Path $localpath\"$env:computername"-servicedlls.csv -Encoding UTF8 -NoTypeInformation

# 13) SOFTWARE
$ErrorActionPreference = 'SilentlyContinue'
gwmi -class Win32_StartupCommand |
    Select-Object @{Name = 'Computername'; Expression = { $env:COMPUTERNAME } },
    @{Name = 'AuditDate'; Expression = { Get-Date -UFormat %s } }, 
    Name, 
    Command, 
    Location, 
    User |  
        Export-Csv -Path $localpath\"$env:computername"-startups.csv -Encoding UTF8 -NoTypeInformation


## USBHISTORY

# 14) USB Storage device history
$ErrorActionPreference = 'SilentlyContinue'
Get-ItemProperty -ea 0 hklm:\system\currentcontrolset\enum\usbstor\*\* | 
    Select-Object @{Name = 'Computername'; Expression = { $env:COMPUTERNAME } }, 
    @{Name = 'AuditDate'; Expression = { Get-Date -UFormat %s } }, 
    @{Label = 'HardwareiD'; Expression = { ($_.HardwareiD -split ",")[1] } }, 
    @{Label = 'SerialNo'; Expression = { $_.PSChildName } }, 
    Class, 
    Service | 
        Where-Object { $_.HardwareID -notlike '%vid%' } | 
            Export-Csv -Path $localpath\"$env:computername"-usbdev.csv -Encoding UTF8 -NoTypeInformation

# 15) USB Storage devices with serial number
$ErrorActionPreference = 'SilentlyContinue'
Get-ItemProperty -Path hklm:\system\currentcontrolset\enum\usbstor\*\* | 
    ForEach-Object { $P = $_.PSChildName; Get-ItemProperty hklm:\SOFTWARE\Microsoft\"Windows Portable Devices"\*\* |
            Where-Object { $_.PSChildName -like "*$P*" } | 
                Select-Object @{Name = 'Computername'; Expression = { $env:COMPUTERNAME } },
                @{Name = 'AuditDate'; Expression = { Get-Date -UFormat %s } },
                FriendlyName, @{Label = 'ProductName'; Expression = { ($_.PSChildName -split "&")[5] } },
                @{Label = 'SerialNo'; Expression = { ($_.PSChildName -split "#")[6] } } } | 
                Export-Csv -Path $localpath\"$env:computername"-usbsn.csv -Encoding UTF8 -NoTypeInformation



## FILES

# 16) SELECT Binary Files
$ErrorActionPreference = 'SilentlyContinue'
$localdrives = ([System.IO.DriveInfo]::getdrives() | Where-Object { $_.DriveType -eq 'Fixed' } | Select-Object -ExpandProperty Name)
foreach ($a in $localdrives) {
    Get-ChildItem -Path $a'\*' -Force -Include *.dll, *.exe, *.sys -Recurse -ErrorAction "SilentlyContinue" |
        Where-Object { $_.DirectoryName -notmatch 'common|\\IME\\|\.old\\|recycle|migration|install|setup|migwiz|driverstore|sxs|cache|kb|update|assembly|\.NET' } |
            <#Where-Object { $_.DirectoryName -notlike '*common*' } |
                Where-Object { $_.DirectoryName -notlike '*\IME\*' } |
                    Where-Object { $_.DirectoryName -notlike '*.old\*' } |
                        Where-Object { $_.DirectoryName -notlike '*recycle*' } |
                            Where-Object { $_.DirectoryName -notlike '*migration*' } |
                                Where-Object { $_.DirectoryName -notlike '*install*' } |
                                    Where-Object { $_.DirectoryName -notlike '*setup*' } |
                                        Where-Object { $_.DirectoryName -notlike '*migwiz*' } |
                                            Where-Object { $_.DirectoryName -notlike '*driverstore*' } |
                                                Where-Object { $_.DirectoryName -notlike '*sxs*' } |
                                                    Where-Object { $_.DirectoryName -notlike '*cache*' } |
                                                        Where-Object { $_.DirectoryName -notlike '*kb*' } |
                                                            Where-Object { $_.DirectoryName -notlike '*update*' } |
                                                                Where-Object { $_.DirectoryName -notlike '*assembly*' } |
                                                                    Where-Object { $_.DirectoryName -notlike '*.NET*' } |#>
            Select-Object @{Name = 'Computername'; Expression = { $env:COMPUTERNAME } },
            @{Name = 'AuditDate'; Expression = { Get-Date -UFormat %s } },
            Name,
            Length,
            DirectoryName,
            @{ Label = "CreationTime"; Expression = { $_.CreationTime | Get-Date -UFormat %s } },
            @{ Label = "LastWriteTime"; Expression = { $_.LastWriteTime | Get-Date -UFormat %s } },
            @{ Label = "ProductVersion"; Expression = { ("{0}.{1}.{2}.{3}" -f $_.VersionInfo.FileMajorPart, $_.VersionInfo.FileMinorPart, $_.VersionInfo.FileBuildPart, $_.VersionInfo.FilePrivatePart) } },
            @{ Label = "FileVersion"; Expression = { $_.VersionInfo.FileVersion } },
            @{ Label = "Description"; Expression = { $_.VersionInfo.FileDescription } } |
                ConvertTo-Csv -NoTypeInformation |
                    Out-File -Append $localpath\"$env:computername"-allfiles.csv -Encoding UTF8 
}

# 17) PREFETCH FSDir
$ErrorActionPreference = 'SilentlyContinue'
Get-ChildItem -Path "c:\windows\prefetch" -Force -Include *.pf -Recurse | 
    Select-Object @{Name = 'Computername'; Expression = { $env:COMPUTERNAME } }, 
    @{Name = 'AuditDate'; Expression = { Get-Date -UFormat %s } }, 
    Name, 
    Length, 
    DirectoryName, 
    @{ Label = "CreationTime"; Expression = { $_.CreationTime | Get-Date -UFormat %s } }, 
    @{ Label = "LastWriteTime"; Expression = { $_.LastWriteTime | Get-Date -UFormat %s } },
    @{ Label = "ProductVersion"; Expression = { $_.VersionInfo.ProductVersion } }, 
    @{ Label = "FileVersion"; Expression = { $_.VersionInfo.FileVersion } }, 
    @{ Label = "Description"; Expression = { $_.VersionInfo.FileDescription } } | 
        Export-Csv -Path $localpath\"$env:Computername"-prefetch.csv -Encoding UTF8 -NoTypeInformation


# 18) AMCACHE History 
# adapted from https://raw.githubusercontent.com/davidhowell-tx/PS-WindowsForensics/master/AppCompatCache/Invoke-AppCompatCacheParser.ps1
$ErrorActionPreference = 'SilentlyContinue'
$Path
$EntryArray = @()
$AppCompatCache = $Null
switch ($PSCmdlet.ParameterSetName) {
    "Path" {
        if (Test-Path -Path $Path) {
            $AppCompatCache = Get-Content -Path $Path | Select-String -Pattern "[A-F0-9][A-F0-9]," | 
                ForEach-Object { $_ -replace "(\\|,|`"AppCompatCache`"=hex:|\s)", "" }
            $AppCompatCache = $AppCompatCache -join ""
            $AppCompatCache = $AppCompatCache -split "(?<=\G\w{2})(?=\w{2})" | 
                ForEach-Object { [System.Convert]::ToByte( $_, 16 ) }
        }
    }
    Default {
        if (!(Get-PSDrive -Name HKLM -PSProvider Registry)) {
            New-PSDrive -Name HKLM -PSProvider Registry -Root HKEY_LOCAL_MACHINE
        }
        if (Get-ItemProperty -Path 'HKLM:\System\CurrentControlSet\Control\Session Manager\AppCompatCache\' -ErrorAction SilentlyContinue | 
                Select-Object -ExpandProperty AppCompatCache) {
            $AppCompatCache = Get-ItemProperty -Path 'HKLM:\System\CurrentControlSet\Control\Session Manager\AppCompatCache\' -ErrorAction SilentlyContinue | 
                Select-Object -ExpandProperty AppCompatCache
        } else {
            $AppCompatCache = Get-ItemProperty -Path 'HKLM:\System\CurrentControlSet\Control\Session Manager\AppCompatibility\AppCompatCache' -ErrorAction SilentlyContinue | 
                Select-Object -ExpandProperty AppCompatCache
        }
    }
}
if ($AppCompatCache -ne $null) {
    $MemoryStream = New-Object System.IO.MemoryStream(, $AppCompatCache)
    $BinReader = New-Object System.IO.BinaryReader $MemoryStream
    $UnicodeEncoding = New-Object System.Text.UnicodeEncoding
    $ASCIIEncoding = New-Object System.Text.ASCIIEncoding
    $Header = ([System.BitConverter]::ToString($BinReader.ReadBytes(4))) -replace "-", ""
    switch ($Header) {
        "30000000" {
            $BinReader.ReadBytes(32) | Out-Null
            $NumberOfEntries = [System.BitConverter]::ToUInt32($BinReader.ReadBytes(4), 0)
            $BinReader.ReadBytes(8) | Out-Null
            for ($i = 0; $i -lt $NumberOfEntries; $i++) {
                $TempObject = "" | Select-Object -Property FileName, LastModifiedTime, Data
                $TempObject | Add-Member -MemberType NoteProperty -Name "Tag" -Value ($ASCIIEncoding.GetString($BinReader.ReadBytes(4)))
                $BinReader.ReadBytes(4) | Out-Null
                $CacheEntrySize = [System.BitConverter]::ToUInt32($BinReader.ReadBytes(4), 0)
                $NameLength = [System.BitConverter]::ToUInt16($BinReader.ReadBytes(2), 0)
                $TempObject.FileName = $UnicodeEncoding.GetString($BinReader.ReadBytes($NameLength))
                $TempObject.LastModifiedTime = [DateTime]::FromFileTime([System.BitConverter]::ToUInt64($BinReader.ReadBytes(8), 0)).ToString("G")
                $DataLength = [System.BitConverter]::ToUInt32($BinReader.ReadBytes(4), 0)
                $TempObject.Data = $ASCIIEncoding.GetString($BinReader.ReadBytes($DataLength))
                $EntryArray += $TempObject
            }
            $EntryArray | 
                Select-Object @{Name = 'Computername'; Expression = { $env:COMPUTERNAME } }, 
                @{Name = 'AuditDate'; Expression = { Get-Date -UFormat %s } }, 
                @{Label = 'Command'; Expression = { ($_.FileName -split "\\")[-1] } }, 
                @{Label = 'Path'; Expression = { $_.FileName } }, 
                @{Label = 'LastMod'; Expression = { $_.LastModifiedTime | Get-Date -UFormat %s } } |
                    Export-Csv -Path $localpath\"$env:Computername"-amcache.csv -Encoding UTF8 -NoTypeInformation
        }
        "34000000" {
            $BinReader.ReadBytes(36) | Out-Null
            $NumberOfEntries = [System.BitConverter]::ToUInt32($BinReader.ReadBytes(4), 0)
            $BinReader.ReadBytes(8) | Out-Null
            for ($i = 0; $i -lt $NumberOfEntries; $i++) {
                $TempObject = "" | Select-Object -Property FileName, LastModifiedTime, Data
                $TempObject | Add-Member -MemberType NoteProperty -Name "Tag" -Value ($ASCIIEncoding.GetString($BinReader.ReadBytes(4)))
                $BinReader.ReadBytes(4) | Out-Null
                $CacheEntrySize = [System.BitConverter]::ToUInt32($BinReader.ReadBytes(4), 0)
                $NameLength = [System.BitConverter]::ToUInt16($BinReader.ReadBytes(2), 0)
                $TempObject.FileName = $UnicodeEncoding.GetString($BinReader.ReadBytes($NameLength))
                $TempObject.LastModifiedTime = [DateTime]::FromFileTime([System.BitConverter]::ToUInt64($BinReader.ReadBytes(8), 0)).ToString("G")
                $DataLength = [System.BitConverter]::ToUInt32($BinReader.ReadBytes(4), 0)
                $TempObject.Data = $ASCIIEncoding.GetString($BinReader.ReadBytes($DataLength))
                $EntryArray += $TempObject
            }
            $EntryArray | 
                Select-Object @{Name = 'Computername'; Expression = { $env:COMPUTERNAME } }, 
                @{Name = 'AuditDate'; Expression = { Get-Date -UFormat %s } }, 
                @{Label = 'Command'; Expression = { ($_.FileName -split "\\")[-1] } }, 
                @{Label = 'Path'; Expression = { $_.FileName } }, 
                @{Label = 'LastMod'; Expression = { $_.LastModifiedTime | Get-Date -UFormat %s } } |
                    Export-Csv -Path $localpath\"$env:Computername"-amcache.csv -Encoding UTF8 -NoTypeInformation
        }
        "80000000" {
            $Offset = [System.BitConverter]::ToUInt32($AppCompatCache[0..3], 0)
            $Tag = [System.BitConverter]::ToString($AppCompatCache[$Offset..($Offset + 3)], 0) -replace "-", ""
            if ($Tag -eq "30307473" -or $Tag -eq "31307473") {
                $MemoryStream.Position = ($Offset)
                while ($MemoryStream.Position -lt $MemoryStream.Length) {
                    $EntryTag = [System.BitConverter]::ToString($BinReader.ReadBytes(4), 0) -replace "-", ""
                    if ($EntryTag -eq "30307473" -or $EntryTag -eq "31307473") {
                        $BinReader.ReadBytes(4) | Out-Null
                        $TempObject = "" | Select-Object -Property Name, Time
                        $JMP = [System.BitConverter]::ToUInt32($BinReader.ReadBytes(4), 0)
                        $SZ = [System.BitConverter]::ToUInt16($BinReader.ReadBytes(2), 0)
                        $TempObject.Name = $UnicodeEncoding.GetString($BinReader.ReadBytes($SZ + 2))
                        $BinReader.ReadBytes(8) | Out-Null
                        $TempObject.Time = [DateTime]::FromFileTime([System.BitConverter]::ToUInt64($BinReader.ReadBytes(8), 0)).ToString("G")
                        $BinReader.ReadBytes(4) | Out-Null
                        $TempObject
                    } else {
                        $Exit = $False
                        while ($Exit -ne $true) {
                            $Byte1 = [System.BitConverter]::ToString($BinReader.ReadBytes(1), 0) -replace "-", ""
                            if ($Byte1 -eq "30" -or $Byte1 -eq "31") {
                                $Byte2 = [System.BitConverter]::ToString($BinReader.ReadBytes(1), 0) -replace "-", ""
                                if ($Byte2 -eq "30") {
                                    $Byte3 = [System.BitConverter]::ToString($BinReader.ReadBytes(1), 0) -replace "-", ""
                                    if ($Byte3 -eq "74") {
                                        $Byte4 = [System.BitConverter]::ToString($BinReader.ReadBytes(1), 0) -replace "-", ""
                                        if ($Byte4 -eq "73") {
                                            # Verified a correct tag for a new entry
                                            # Scroll back 4 bytes and exit the scan loop
                                            $MemoryStream.Position = ($MemoryStream.Position - 4)
                                            $Exit = $True
                                        } else {
                                            $MemoryStream.Position = ($MemoryStream.Position - 3)
                                        }
                                    } else {
                                        $MemoryStream.Position = ($MemoryStream.Position - 2)
                                    }
                                } else {
                                    $MemoryStream.Position = ($MemoryStream.Position - 1)
                                }
                            }
                        }
                    }
                }
            } elseif ($Tag -eq "726F7473") {
                $MemoryStream.Position = ($Offset + 8)
                while ($MemoryStream.Position -lt $MemoryStream.Length) {
                    #Parse the metadata for the entry and add to a custom object
                    $TempObject = "" | Select-Object -Property Name, Time
                    $JMP = [System.BitConverter]::ToUInt32($BinReader.ReadBytes(4), 0)
                    $TempObject.Time = [DateTime]::FromFileTime([System.BitConverter]::ToUInt64($BinReader.ReadBytes(8), 0)).ToString("G")
                    $SZ = [System.BitConverter]::ToUInt16($BinReader.ReadBytes(2), 0)
                    $TempObject.Name = $UnicodeEncoding.GetString($BinReader.ReadBytes($SZ))
                    $EntryArray += $TempObject
                }
            }
            $EntryArray | 
                Select-Object @{Name = 'Computername'; Expression = { $env:COMPUTERNAME } }, 
                @{Name = 'AuditDate'; Expression = { Get-Date -UFormat %s } }, 
                @{Label = 'Command'; Expression = { ($_.Name -split "\\")[-1] } }, 
                @{Label = 'Path'; Expression = { $_.Name } }, 
                @{Label = 'LastMod'; Expression = { $_.Time | Get-Date -UFormat %s } } |
                    Export-Csv -Path $localpath\"$env:Computername"-amcache.csv -Encoding UTF8 -NoTypeInformation
        }
        "EE0FDCBA" {
            $NumberOfEntries = [System.BitConverter]::ToUInt32($BinReader.ReadBytes(4), 0)
            $MemoryStream.Position = 128
            $Length = [System.BitConverter]::ToUInt16($BinReader.ReadBytes(2), 0)
            $MaxLength = [System.BitConverter]::ToUInt16($BinReader.ReadBytes(2), 0)
            $Padding = [System.BitConverter]::ToUInt32($BinReader.ReadBytes(4), 0)
            $MemoryStream.Position = 128
            if (($MaxLength - $Length) -eq 2) {
                if ($Padding -eq 0) {
                    for ($i = 0; $i -lt $NumberOfEntries; $i++) {
                        $TempObject = "" | Select-Object -Property Name, Length, MaxLength, Padding, Offset0, Offset1, Time, Flag0, Flag1
                        $TempObject.Length = [System.BitConverter]::ToUInt16($BinReader.ReadBytes(2), 0)
                        $TempObject.MaxLength = [System.BitConverter]::ToUInt16($BinReader.ReadBytes(2), 0)
                        $TempObject.Padding = [System.BitConverter]::ToUInt32($BinReader.ReadBytes(4), 0)
                        $TempObject.Offset0 = [System.BitConverter]::ToUInt32($BinReader.ReadBytes(4), 0)
                        $TempObject.Offset1 = [System.BitConverter]::ToUInt32($BinReader.ReadBytes(4), 0)
                        $TempObject.Time = [DateTime]::FromFileTime([System.BitConverter]::ToUInt64($BinReader.ReadBytes(8), 0)).ToString("G")
                        $TempObject.Flag0 = [System.BitConverter]::ToUInt32($BinReader.ReadBytes(4), 0)
                        $TempObject.Flag1 = [System.BitConverter]::ToUInt32($BinReader.ReadBytes(4), 0)
                        $TempObject.Name = ($UnicodeEncoding.GetString($AppCompatCache[$TempObject.Offset0..($TempObject.Offset0 + $TempObject.Length - 1)])) -replace "\\\?\?\\", ""
                        $Nothing = $BinReader.ReadBytes(16)
                        $EntryArray += $TempObject
                    }
                } else {
                    for ($i = 0; $i -lt $NumberOfEntries; $i++) {
                        $TempObject = "" | Select-Object -Property Name, Length, MaxLength, Offset, Time, Flag0, Flag1
                        $TempObject.Length = [System.BitConverter]::ToUInt16($BinReader.ReadBytes(2), 0)
                        $TempObject.MaxLength = [System.BitConverter]::ToUInt16($BinReader.ReadBytes(2), 0)
                        $TempObject.Offset = [System.BitConverter]::ToUInt32($BinReader.ReadBytes(4), 0)
                        $TempObject.Time = [DateTime]::FromFileTime([System.BitConverter]::ToUInt64($BinReader.ReadBytes(8), 0)).ToString("G")
                        $TempObject.Flag0 = [System.BitConverter]::ToUInt32($BinReader.ReadBytes(4), 0)
                        $TempObject.Flag1 = [System.BitConverter]::ToUInt32($BinReader.ReadBytes(4), 0)
                        $TempObject.Name = ($UnicodeEncoding.GetString($AppCompatCache[$TempObject.Offset0..($TempObject.Offset0 + $TempObject.Length - 1)])) -replace "\\\?\?\\", ""
                        $Nothing = $BinReader.ReadBytes(16)
                        $EntryArray += $TempObject
                    }
                }
            }
            $EntryArray | 
                Select-Object @{Name = 'Computername'; Expression = { $env:COMPUTERNAME } }, 
                @{Name = 'AuditDate'; Expression = { Get-Date -UFormat %s } }, 
                @{Label = 'Command'; Expression = { ($_.Name -split "\\")[-1] } }, 
                @{Label = 'Path'; Expression = { $_.Name } }, 
                @{Label = 'LastMod'; Expression = { $_.Time | Get-Date -UFormat %s } } |
                    Export-Csv -Path $localpath\"$env:Computername"-amcache.csv -Encoding UTF8 -NoTypeInformation 
        }
        "FE0FDCBA" {
            $NumberOfEntries = [System.BitConverter]::ToUInt32($AppCompatCache[4..7], 0)
            $Padding = [System.BitConverter]::ToUInt32($AppCompatCache[12..15], 0)
            $MemoryStream.Position = 8
            if ($Padding -eq 0) {
                for ($i = 0; $i -lt $NumberOfEntries; $i++) {
                    $TempObject = "" | Select-Object -Property Name, ModifiedTime, FileSize, Executed
                    $Length = [System.BitConverter]::ToUInt16($BinReader.ReadBytes(2), 0)
                    $MaxLength = [System.BitConverter]::ToUInt16($BinReader.ReadBytes(2), 0)
                    $Padding = [System.BitConverter]::ToUInt32($BinReader.ReadBytes(4), 0)
                    $Offset = [System.BitConverter]::ToUInt32($BinReader.ReadBytes(4), 0)
                    $BinReader.ReadBytes(4) | Out-Null
                    $TempObject.ModifiedTime = [DateTime]::FromFileTime([System.BitConverter]::ToUInt64($BinReader.ReadBytes(8), 0)).ToString("G")
                    $TempObject.FileSize = [System.BitConverter]::ToUInt64($BinReader.ReadBytes(8), 0)
                    $TempObject.Name = $Unicode.GetString($AppCompatCache[$Offset..($Offset + $Length)])
                    if ($TempObject.FileSize -gt 0) {
                        $TempObject.Executed = $True
                    } else {
                        $TempObject.Executed = $False
                    }
                    $EntryArray += $TempObject
                    Remove-Variable Length
                    Remove-Variable Padding
                    Remove-Variable MaxLength
                    Remove-Variable Offset
                    Remove-Variable TempObject
                }
                $EntryArray | 
                    Select-Object @{Name = 'Computername'; Expression = { $env:COMPUTERNAME } }, 
                    @{Name = 'AuditDate'; Expression = { Get-Date -UFormat %s } }, 
                    @{Label = 'Command'; Expression = { ($_.Name -split "\\")[-1] } }, 
                    @{Label = 'Path'; Expression = { $_.Name } }, 
                    @{Label = 'LastMod'; Expression = { $_.ModifiedTime | Get-Date -UFormat %s } } |
                        Export-Csv -Path $localpath\"$env:Computername"-amcache.csv -Encoding UTF8 -NoTypeInformation
            } else {
                for ($i = 0; $i -lt $NumberOfEntries; $i++) {
                    $TempObject = "" | Select-Object -Property FileName, ModifiedTime, FileSize
                    $Length = [System.BitConverter]::ToUInt16($BinReader.ReadBytes(2), 0)
                    $MaxLength = [System.BitConverter]::ToUInt16($BinReader.ReadBytes(2), 0)
                    $Offset = [System.BitConverter]::ToUInt32($BinReader.ReadBytes(4), 0)
                    $TempObject.ModifiedTime = [DateTime]::FromFileTime([System.BitConverter]::ToUInt64($BinReader.ReadBytes(8), 0)).ToString("G")
                    $TempObject.FileSize = [System.BitConverter]::ToUInt64($BinReader.ReadBytes(8), 0)
                    $TempObject.FileName = $Unicode.GetString($AppCompatCache[$Offset..($Offset + $Length)])
                    $EntryArray += $TempObject
                    Remove-Variable Length
                    Remove-Variable MaxLength
                    Remove-Variable Offset
                    Remove-Variable TempObject
                }
                $EntryArray | 
                    Select-Object @{Name = 'Computername'; Expression = { $env:COMPUTERNAME } }, 
                    @{Name = 'AuditDate'; Expression = { Get-Date -UFormat %s } }, 
                    @{Label = 'Command'; Expression = { ($_.FileName -split "\\")[-1] } }, 
                    @{Label = 'Path'; Expression = { $_.FileName } }, 
                    @{Label = 'LastMod'; Expression = { $_.ModifiedTime | Get-Date -UFormat %s } } |
                        Export-Csv -Path $localpath\"$env:Computername"-amcache.csv -Encoding UTF8 -NoTypeInformation
            }
        }
        "EFBEADDE" {
            $NumberOfEntries = [System.BitConverter]::ToUInt32($BinReader.ReadBytes(4), 0)
            $NumberOfLRUEntries = [System.BitConverter]::ToUInt32($BinReader.ReadBytes(4), 0)
            $BinReader.ReadBytes(4) | Out-Null
            for ($i = 0; $i -lt $NumberOfLRUEntries; $i++) {
                $LRUEntry
            }
            $MemoryStream.Position = 400
            for ($i = 0; $i -lt $NumberOfEntries; $i++) {
                $TempObject = "" | Select-Object -Property FileName, LastModifiedTime, Size, LastUpdatedTime
                $TempObject.FileName = ($UnicodeEncoding.GetString($BinReader.ReadBytes(528))) -replace "\\\?\?\\", ""
                $TempObject.LastModifiedTime = [DateTime]::FromFileTime([System.BitConverter]::ToUInt64($BinReader.ReadBytes(8), 0)).ToString("G")
                $TempObject.FileSize = [System.BitConverter]::ToUInt64($BinReader.ReadBytes(8), 0)
                $TempObject.LastUpdatedTime = [DateTime]::FromFileTime([System.BitConverter]::ToUInt64($BinReader.ReadBytes(8), 0)).ToString("G")
                $EntryArray += $TempObject
            }
            $EntryArray | 
                Select-Object @{Name = 'Computername'; Expression = { $env:COMPUTERNAME } }, 
                @{Name = 'AuditDate'; Expression = { Get-Date -UFormat %s } }, 
                @{Label = 'Command'; Expression = { ($_.FileName -split "\\")[-1] } }, 
                @{Label = 'Path'; Expression = { $_.FileName } }, 
                @{Label = 'LastMod'; Expression = { $_.LastModifiedTime | Get-Date -UFormat %s } } |
                    Export-Csv -Path $localpath\"$env:Computername"-amcache.csv -Encoding UTF8 -NoTypeInformation
        }
    } 
} 


## EVENTS

# 19) REMOTE Logins
$ErrorActionPreference = 'SilentlyContinue'
$Events = Get-WinEvent -FilterHashtable @{Logname = ’Security’; ID = 4624 }
ForEach ($Event in $Events) { 
    $eventXML = [xml]$Event.ToXml() 
    For ($i = 0; $i -lt $eventXML.Event.EventData.Data.Count; $i++) { 
        Add-Member -InputObject $Event -MemberType NoteProperty -Force -Name $eventXML.Event.EventData.Data[$i].name -Value $eventXML.Event.EventData.Data[$i].’#text’ 
    } 
} 
$Events | 
    Select-Object @{Name = 'Computername'; Expression = { $env:COMPUTERNAME } },
    @{Name = 'AuditDate'; Expression = { Get-Date -UFormat %s } },
    @{Name = 'EventID'; Expression = { $_.id } },
    @{Name = 'EventTime'; Expression = { $_.timecreated | Get-Date -UFormat %s } },
    @{Name = 'UserName'; Expression = { $_.targetusername } },
    @{Name = 'Domain'; Expression = { $_.targetdomainname } },
    @{Name = 'WorkstationName'; Expression = { $_.workstationname } },
    @{Name = 'IpAddress'; Expression = { $_.ipaddress } },
    @{Name = 'SourcePort'; Expression = { $_.sourceport } },
    @{Name = 'LogonType'; Expression = { $_.logontype } },
    @{Name = 'LoginProcessName'; Expression = { $_.loginprocessname } },
    @{Name = 'ProcessName'; Expression = { $_.processname } } | 
        Where-Object { $_.LogonType -like '3' -or $_.LogonType -like '4' -or $_.LogonType -like '8' -or $_.LogonType -like '10' } | 
            Where-Object { $_.IpAddress -notlike '-' } |
                Where-Object { $_.processname -notlike '-' } |
                    Export-Csv -Path $localpath\"$env:computername"-remotelogons.csv -Encoding UTF8 -NoTypeInformation

## SERVICES

# 20) NEW Security Logged Services
$ErrorActionPreference = 'SilentlyContinue'
$Events = Get-WinEvent -FilterHashtable @{Logname = ’Security’; ID = 4697 }
ForEach ($Event in $Events) { 
    $eventXML = [xml]$Event.ToXml() 
    For ($i = 0; $i -lt $eventXML.Event.EventData.Data.Count; $i++) { 
        Add-Member -InputObject $Event -MemberType NoteProperty -Force -Name $eventXML.Event.EventData.Data[$i].name -Value $eventXML.Event.EventData.Data[$i].’#text’ 
    } 
} 
$Events | 
    Select-Object @{Name = 'Computername'; Expression = { $env:COMPUTERNAME } },
    @{Name = 'AuditDate'; Expression = { Get-Date -UFormat %s } },
    @{Name = 'EventID'; Expression = { $_.id } },
    @{Name = 'TimeGenerated'; Expression = { $_.timecreated | Get-Date -UFormat %s } },
    @{Name = 'UserName'; Expression = { $_.subjectusername } },
    @{Name = 'UserDomain'; Expression = { $_.subjectdomainname } },
    @{Name = 'ServiceName'; Expression = { $_.servicename } },
    @{Name = 'Filename'; Expression = { $_.servicefilename } },
    @{Name = 'StartType'; Expression = { $_.servicestarttype } },
    @{Name = 'ServiceAccount'; Expression = { $_.serviceaccount } } | 
        Export-Csv -Path $localpath\"$env:computername"-secsvcstart.csv -Encoding UTF8 -NoTypeInformation

# 21) NEW System Logged Services
$ErrorActionPreference = 'SilentlyContinue'
$Events = Get-WinEvent -FilterHashtable @{Logname = ’System’; ID = 7045 }
ForEach ($Event in $Events) { 
    $eventXML = [xml]$Event.ToXml() 
    For ($i = 0; $i -lt $eventXML.Event.EventData.Data.Count; $i++) { 
        Add-Member -InputObject $Event -MemberType NoteProperty -Force -Name $eventXML.Event.EventData.Data[$i].name -Value $eventXML.Event.EventData.Data[$i].’#text’ 
    } 
} 
$Events | 
    Select-Object @{Name = 'Computername'; Expression = { $env:COMPUTERNAME } },
    @{Name = 'AuditDate'; Expression = { Get-Date -UFormat %s } },
    @{Name = 'EventID'; Expression = { $_.id } },
    @{Name = 'TimeGenerated'; Expression = { $_.timecreated | Get-Date -UFormat %s } },
    @{Name = 'UserName'; Expression = { $_.accountname } },
    @{Name = 'ServiceName'; Expression = { $_.servicename } },
    @{Name = 'Filename'; Expression = { $_.imagepath } },
    @{Name = 'ServiceType'; Expression = { $_.servicetype } },
    @{Name = 'ServiceStartType'; Expression = { $_.starttype } } | 
        Export-Csv -Path $localpath\"$env:computername"-syssvcstart.csv -Encoding UTF8 -NoTypeInformation

# 22) Missing Patches
$ErrorActionPreference = 'SilentlyContinue'
$Patches = @(
    $MUS = New-Object -com Microsoft.Update.Session
    $Usearch = $MUS.CreateUpdateSearcher()
    $Usresult = $Usearch.Search("IsInstalled=0 and Type='Software'")
    ForEach ($update in $Usresult.Updates) {
        $update | Select-Object @{Name = 'Computername'; Expression = { $env:COMPUTERNAME } },
        @{Name = 'AuditDate'; Expression = { Get-Date -UFormat %s } },
        @{Name = 'Patch'; Expression = { $Update.Title } }
    })  
$Patches | ConvertTo-Csv -NoTypeInformation |
    Out-File $localpath\"$env:computername"-patches.csv -Encoding UTF8 


## CLEANUP

<# ZIP Results
    $ErrorActionPreference = 'SilentlyContinue'
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
    $ErrorActionPreference = 'SilentlyContinue'
    Move-Item $localpath\*.zip $networkshare -Force

    # REMOVE Files and Folder
    #invoke-command -scriptblock {del $localpath\*.csv}
    #invoke-command -scriptblock {rmdir $localpath}
    $ErrorActionPreference = 'SilentlyContinue'
    Remove-Item $localpath -Recurse -Force

    # Write to success to logfile
    $ErrorActionPreference = 'SilentlyContinue'
    Add-Content $networkshare\CRA_Collection.log "$logtime - SUCCESS : $myFQDN has been audited. The collection archive was moved to $networkshare"
    #exit#>
<#}

Else {
    # Write to failure to logfile
    $ErrorActionPreference = 'SilentlyContinue'
    Add-Content $networkshare\CRA_Collection.log "$logtime - FAILURE : A previous collection for $myFQDN was found at the networkshare. Script terminated on $myFQDN"
    #exit
}#>
