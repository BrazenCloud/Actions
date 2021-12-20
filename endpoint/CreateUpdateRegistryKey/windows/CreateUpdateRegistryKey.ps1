
param ([Parameter(Mandatory)]$RegistryPath, [Parameter(Mandatory)]$Name, [Parameter(Mandatory)]$Value)

$Message = "Unknown"
$Success = $true
$Action = "???"

# Remove-ItemProperty -Path "HKLM:\Software\SmpApplication" -Name "SmpProperty"
# get the entry
# (Get-Item -Path HKLM:\Software\CommunityBlog\Scripts).GetValue("Version") 

try {
    # check if path exists, if not create it
    If (-NOT (Test-Path $RegistryPath)) {
        New-Item -Path $RegistryPath -Force | Out-Null
    }
    # verify path exists, if not set success to false
    If (-NOT (Test-Path $RegistryPath)) {
        $Message = "Unable to create/update RegistryPath $RegistryPath"
        $Success = $false
    } else {
        # if path exists, check if the entry exists
        $v = (Get-Item -Path $RegistryPath).GetValue("$Name")
        if ($v -ne "") {
            # if entry exists, this is an update
            $Action = "updated"
            Set-ItemProperty -Path $RegistryPath -Name $Name -Value $Value -Force | Out-Null
        } else {
            # if entry does not exist this is a new entry
            $Action = "created"
            New-ItemProperty -Path $RegistryPath -Name $Name -Value $Value -PropertyType DWORD -Force | Out-Null
        }
        # check if it was added correctly
        $v = (Get-Item -Path $RegistryPath).GetValue("$Name")
        if ($v -ne $Value) {
            $Message = "Unable to create/update $Name in RegistryPath $RegistryPath"
            $Success = $false
        } else {
            $Message = "The RegistryPath $RegistryPath was $Action successfully"
        }
    }
} catch {
    $FailedItem = $_.Exception.ItemName
    $Message = $_.Exception.Message
    $Success = $false
} finally {
    $Output = Select-Object @{n='RegistryPath';e={$RegistryPath}},@{n='Name';e={$Name}},@{n='Value';e={$Value}},@{n='Successful';e={$Success}},@{n='Message';e={$Message}} -InputObject '' | ConvertTo-json
    Write-Host($Output)
}
