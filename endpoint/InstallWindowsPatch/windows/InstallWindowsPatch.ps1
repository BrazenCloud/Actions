
param ([Parameter(Mandatory)]$Patch,[Parameter(Mandatory)]$Reboot)

$Message = "Unknown"
$Success = $true
$Action = "???"

try {

    # enable Ttls to allow installing package provider
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

    # Install Package Provider and PSWindowsUpdate Module
    Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force
    Install-Module -Name PSWindowsUpdate -Force

    # Import the PSWindowsUpdate Module
    Import-Module PSWindowsUpdate

    $Cur_Date = date
    if ($Reboot == "True") {
        Install-WindowsUpdate -AcceptAll -AutoReboot -KBArticleID "$Patch"
    } else {
        Install-WindowsUpdate -AcceptAll -KBArticleID "$Patch"
    }

    $Json_obj = Get-WUHistory | Convertto-Json | Convertfrom-Json
    $Last_update_date = $Json_obj[0].Date

    # Verify latest update was successful
    if ($Last_update_date -lt $Cur_Date) {
        $Success = $false
        $Message = "The latest patch date is invalid"
    } else if ($Json_obj[0].Result -ne "Succeeded") {
        $Success = $false
        $Message = "The patch $Patch was not installed successfully"
    } else {
        $Message = "Successfully installed patch $Patch"
    }
} catch {
    $FailedItem = $_.Exception.ItemName
    $Message = $_.Exception.Message
    $Success = $false
} finally {
    $Output = Select-Object @{n='Patch';e={$Patch}},@{n='Successful';e={$Success}},@{n='Message';e={$Message}} -InputObject '' | ConvertTo-json
    Write-Host($Output)
}
