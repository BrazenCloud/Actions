Function Add-LogonAsAServiceUser {
    param (
        [string]$UserName
    )
    # Find the user SID
    $sid = [System.Security.Principal.NTAccount]::new($username).Translate([System.Security.Principal.SecurityIdentifier]).Value

    # Clean up files, if they exist
    $files = 'import.inf','export.inf','secedt.sdb'
    foreach ($file in $files) {
        if (Test-Path .\$file) {
            Remove-Item .\$file -Force
        }
    }

    # Export the settings
    secedit /export /cfg .\export.inf

    # Find the existing logon as a service accounts
    $existingSids = (Select-String .\export.inf -Pattern "SeServiceLogonRight").Line

    # Build the update file
    $updateStr = @"
[Unicode]
Unicode=yes
[System Access]
[Event Audit]
[Registry Values]
[Version]
signature="`$CHICAGO$"
Revision=1
[Profile Description]
Description=GrantLogOnAsAService security template
[Privilege Rights]
$existingSids,*$sid
"@
    $updateStr | Out-File .\import.inf

    secedit /import /db .\secedt.sdb /cfg .\import.inf
    secedit /configure /db .\secedt.sdb
    #gpupdate /Target:Computer
    foreach ($file in $files) {
        Remove-Item .\$file -Force
    }
}

$settings = Get-Content .\settings.json | ConvertFrom-Json
$settings

$settings | Select * -ExcludeProperty 'User Password' | ConvertTo-Json | Out-File .\settings.json -Force

<#
PowerShell 7:
$ssPw = ConvertTo-SecureString $settings.'User Password' -AsPlainText -Force
$credential = [pscredential]::New($settings.'User Name',$ssPw)

Set-Service -Name $settings.'Service Name' -Credential $credential -Verbose
#>

# Windows PowerShell

# Allow the user to logon as a service
Add-LogonAsAServiceUser -UserName $settings.'User Name'

# Update the service
sc.exe config `"$($settings.'Service Name')`" obj=`"$($settings.'User Name')`" password=`"$($settings.'User Password')`"

# Restart the service
# Needs to be run by a separate process
$date = (Get-Date).AddMinutes(1)
schtasks /create /TN RestartService /RU SYSTEM /TR "cmd /c sc stop runwayrunnerservice && sc start runwayrunnerservice" /SC ONCE /ST "$($date.Hour):$($date.Minute)" /F