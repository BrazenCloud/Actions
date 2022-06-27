$settings = Get-Content .\settings.json | ConvertFrom-Json

if ($settings.'Harden Agent Files'.ToString() -eq 'true') {
    # Default working dir is installPath\work_tree\id\id
    $agentPath = '..\..\..'

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