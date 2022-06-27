$settings = Get-Content .\settings.json | ConvertFrom-Json

# Default working dir is installPath\work_tree\id\id
$agentPath = (Resolve-Path '..\..\..').Path

if ($settings.'Harden Agent Folder Access'.ToString() -eq 'true') {
    # Identities to remove
    $removeIds = @(
        [System.Security.Principal.NTAccount]'BUILTIN\Users'
    )

    # Paths to harden
    $hardenPaths = @(
        "$agentPath\result_cache",
        "$agentPath\work_tree",
        "$agentPath\runner_settings.json"
    )

    foreach ($path in $hardenPaths) {
        Write-Host "Hardening '$path'"
        # Build ACL object
        $acl = Get-Acl $path

        # Disable Inheritance, preserve existing access
        $acl.SetAccessRuleProtection($true, $true)

        # Remove Users
        $acl.Access | Where-Object { $removeIds -contains $_.IdentityReference } | ForEach-Object {
            $acl.RemoveAccessRule($_)
        }
        Set-Acl $path -AclObject $acl
    }
}

if ($settings.'Reset Folder Access to Default'.ToString() -eq 'true') {
    $modelFolder = Split-Path $agentPath
    function Reset-FolderPermissionsRecursively {
        param (
            [Parameter(Mandatory = $true)][string]$modelFolder,
            [Parameter(Mandatory = $true)][string]$targetFolder
        )
    
        # Reset permissions for parent folder and remove explicit (non-inherited) permissions
        $modelFolderAcl = Get-Acl -Path $modelFolder
        Write-Host "Setting permissions on $targetFolder to match $modelFolder"
        Set-Acl -Path $targetFolder -AclObject $modelFolderAcl
        $acl = Get-Acl $targetFolder
        $aces = $acl.Access
        foreach ($ace in $aces) {
            if ($ace.IsInherited -eq $FALSE) {
                #Write-Host "Removing $ace on $targetFolder"
                $acl.RemoveAccessRule($ace)
                Set-Acl $targetFolder $acl
            }
        }
    
        # Reset permissions for parent folder's children and remove explicit (non-inherited) permissions
        Get-ChildItem $targetFolder -Recurse -Attributes d | ForEach-Object {
            #Write-Host "Setting permissions on" $_.fullName "to match $modelFolder"
            Set-Acl -Path $_.fullName -AclObject $modelFolderAcl
            $acl = Get-Acl $_.FullName
            $aces = $acl.Access
            foreach ($ace in $aces) {
                if ($ace.IsInherited -eq $FALSE) {
                    #Write-Host "Removing $ace on" $_.fullName
                    $acl.RemoveAccessRule($ace)
                    Set-Acl $_.FullName $acl
                }
            }
        }
    }
    Write-Host "Reseting permissions for '$($_.FullName)'"
    Reset-FolderPermissionsRecursively -modelFolder $modelFolder -targetFolder $agentPath
}