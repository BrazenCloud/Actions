# Check to be sure we are on a Domain Controller
# Using Get-WmiObject for backwards compat
# Info: https://docs.microsoft.com/en-us/windows/win32/cimwin32prov/win32-operatingsystem
if ((Get-WmiObject Win32_OperatingSystem).ProductType -eq 2) {
    # Load settings
    $settings = Get-Content .\settings.json | ConvertFrom-Json
    $settings

    # Determine domain
    if ($settings.Domain -eq 'Domain of DC') {
        $domain = (Get-WmiObject Win32_ComputerSystem).Domain
    } else {
        $domain = $settings.Domain
    }

    # Get computername from the parameters

    # Run djoin
    djoin /provision /domain $domain /machine $($settings.'Host Name') /savefile .\results\blob.txt
} else {
    Write-Host 'This is not a DC. That is bad.'
}
Copy-Item .\std.out -Destination .\results