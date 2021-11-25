
param ([Parameter(Mandatory)]$RegistryPath, [Parameter(Mandatory)]$Name)

$Message = "Unknown"
$Success = $true

# Remove-ItemProperty -Path "HKLM:\Software\SmpApplication" -Name "SmpProperty"
# get the entry
# (Get-Item -Path HKLM:\Software\CommunityBlog\Scripts).GetValue("Version") 

try {
    # check if path exists, if path does not exist set success to false
    If (-NOT (Test-Path $RegistryPath)) {
        $Success = $false
        $Message = "Unable to delete entry $name, RegistryPath $RegistryPath doesn't exist"
    } else {
        # if path exists, check if the entry exists
        $v = (Get-Item -Path $RegistryPath).GetValue("$Name") | Out-Null
        # if the entry exists, delete it
        if ($v -ne "") {
            # delete the entry
            Remove-ItemProperty -Path $RegistryPath -Name $Name -Force | Out-Null
            # verify the entry was deleted
            if ((Get-Item -Path $RegistryPath).GetValue("$Name", $null) -ne $null) {
                $Success = $false
                $Message = "Unable to delete entry $name, unexpected error"
            } else {
                $Message = "Successfully deleted entry $name"    
            }
        } else {
            # the entry does not exist so set success to false
            $Success = $false
            $Message = "Unable to delete entry $name, it doesn't exist"
        }
    }
} catch {
    $FailedItem = $_.Exception.ItemName
    $Message = $_.Exception.Message
    $Success = $false
} finally {
    $Output = Select-Object @{n='RegistryPath';e={$RegistryPath}},@{n='Name';e={$Name}},@{n='Successful';e={$Success}},@{n='Message';e={$Message}} -InputObject '' | ConvertTo-json
    Write-Host($Output)
}
