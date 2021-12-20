param ([Parameter(Mandatory)]$Enable, [Parameter(Mandatory)]$NetworkAction, [Parameter(Mandatory)]$Direction, [Parameter(Mandatory)]$Port, [Parameter(Mandatory)]$Protocol, $Address)

$DisplayName = "$Direction-$NetworkAction-$Port"
$Success = $True
$Rule = Get-NetFirewallRule -DisplayName $DisplayName 2> $null; 
$Message = ""
$UpdateType = "Created"

# handle multiple IP addresses
$ips = @()
if ($Address -ne "All") {
    $iparray = $Address.Split(",")
    For ($i=0; $i -lt $iparray.Length; $i++) {
        $ips += $iparray[$i].Trim()
    }
} 

if ($Enable -eq "Enable") {
    # if a rule with the same name exists, update
    if ($Rule) { 
        if ($Address -ne "All") {
            Set-NetFirewallRule -DisplayName $DisplayName -Direction $Direction -Protocol $Protocol -LocalPort $Port -Action $NetworkAction -RemoteAddress $iparray
        } else {
            Set-NetFirewallRule -DisplayName $DisplayName -Direction $Direction -Protocol $Protocol -LocalPort $Port -Action $NetworkAction -RemoteAddress Any
        }
        $UpdateType = "Updated"
    } 
    else { 
        if ($Address -ne "All") {
            New-NetFirewallRule -DisplayName $DisplayName -Direction $Direction -Protocol $Protocol -LocalPort $Port -Action $NetworkAction -RemoteAddress $iparray
        } else {
            New-NetFirewallRule -DisplayName $DisplayName -Direction $Direction -Protocol $Protocol -LocalPort $Port -Action $NetworkAction -RemoteAddress Any
        }
    }
    Enable-NetFirewallRule -DisplayName $DisplayName
} else {
    if ($Rule) { 
        Disable-NetFirewallRule -DisplayName $DisplayName    
        $UpdateType = "Disabled"
    } else {
        $UpdateType = "Does not exist, unable to disable"
        $Success = $False
    }
}
$Message = "$UpdateType rule $DisplayName"
$Output = Select-Object @{n='Port';e={$Port}},@{n='Direction';e={$Direction}},@{n='NetworkAction';e={$NetworkAction}},@{n='Successful';e={$Success}},@{n='Message';e={$Message}} -InputObject '' | ConvertTo-json
Write-Host($Output)