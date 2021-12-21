@CD /d "%~dp0"

rem Collect Hyper-V information
Powershell.exe "Get-VM | Get-VMNetworkAdapter | select VMName, IPAddresses, MacAddress, AdapterId, SwitchName | ConvertTo-JSON | out-file -Encoding utf8 hyperv.json"  >NUL  2>NUL
Powershell.exe "Get-VMSwitch | select Name, SwitchType | ConvertTo-JSON | out-file -Encoding utf8 hyperv-switches.json" >NUL  2>NUL
Powershell.exe "Get-NetIPAddress -AddressFamily IPv4  | select  IPAddress, InterfaceIndex, PrefixLength | ConvertTo-JSON | out-file -Encoding utf8 hyperv-ips.json" >NUL  2>NUL
Powershell.exe "Get-NetAdapter  | select  IfIndex, MacAddress | ConvertTo-JSON | out-file -Encoding utf8 hyperv-adapters.json" >NUL  2>NUL


.\runway -N discover --json map.out
.\runway -N upload --map map.out