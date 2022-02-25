# source for New-RandomPassword: https://rosettacode.org/wiki/Password_generator#PowerShell
function New-RandomPassword {
    <#
    .SYNOPSIS
        Generates one or more passwords.
    .DESCRIPTION
        Generates one or more passwords.
    .PARAMETER Length
        The password length (default = 8).
    .PARAMETER Count
        The number of passwords to generate.
    .PARAMETER Source
        An array of strings containing characters from which the password will be generated.  The default is good for most uses.
    .PARAMETER ExcludeSimilar
        A switch which indicates that visually similar characters should be ignored.
    .EXAMPLE
        New-RandomPassword

        Generates one password of the default length (8 characters).
    .EXAMPLE
        New-RandomPassword -Count 4

        Generates four passwords each of the default length (8 characters).
    .EXAMPLE
        New-RandomPassword -Length 12 -Source abcdefghijklmnopqrstuvwxyz, ABCDEFGHIJKLMNOPQRSTUVWXYZ, 0123456789

        Generates a password with a length of 12 containing at least one char from each string in Source
    .EXAMPLE
        New-RandomPassword -Count 4 -ExcludeSimilar

        Generates four passwords each of the default length (8 characters) while excluding similar characters "Il1O05S2Z".
  #>
    [System.Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSAvoidUsingConvertToSecureStringWithPlainText','')]
    [CmdletBinding(SupportsShouldProcess)]
    [OutputType([string])]
    Param
    (
        [ValidateRange(1, [Int]::MaxValue)]
        [int]$Length = 10,

        [ValidateRange(1, [Int]::MaxValue)]
        [int]$Count = 1,

        [string[]]$Source = @("abcdefghijklmnopqrstuvwxyz", "ABCDEFGHIJKLMNOPQRSTUVWXYZ", "0123456789", "!\`"#$%&'()*+,-./:;<=>?@[]^_{|}~"),

        [switch]$AsSecureString
    )

    Begin {
        [char[][]] $charArrays = $Source
        [char[]]   $allChars = $charArrays | ForEach-Object { $_ }
        [char[]]   $similar = "Il1O05S2Z".ToCharArray()

        $random = New-Object -TypeName System.Security.Cryptography.RNGCryptoServiceProvider

        function Get-Seed {
            $bytes = New-Object -TypeName System.Byte[] -Argument 4
            $random.GetBytes($bytes)
            [BitConverter]::ToUInt32($bytes, 0)
        }

        function Add-PasswordCharacter ([char[]]$From) {
            $key = Get-Seed

            while ($password.ContainsKey($key)) {
                $key = Get-Seed
            }

            $index = (Get-Seed) % $From.Count

            if ($ExcludeSimilar) {
                while ($From[$index] -in $similar) {
                    $index = (Get-Seed) % $From.Count
                }
            }

            $password.Add($key, $From[$index])
        }
    }
    Process {
        for ($i = 1; $i -le $Count; $i++) {
            [hashtable] $password = @{ }

            foreach ($array in $charArrays) {
                if ($password.Count -lt $Length) {
                    Add-PasswordCharacter -From $array # Append to $password
                }
            }

            for ($j = $password.Count; $j -lt $Length; $j++) {
                Add-PasswordCharacter -From $allChars  # Append to $password
            }

            if ($AsSecureString.IsPresent) {
                $plainPw = ($password.GetEnumerator() | Select-Object -ExpandProperty Value) -join ""
                ConvertTo-SecureString $plainPw -AsPlainText -Force
            } else {
                ($password.GetEnumerator() | Select-Object -ExpandProperty Value) -join ""
            }
        }
    }
}

$settings = Get-Content .\settings.json | ConvertFrom-Json
$settings

if ((Get-Module 'ActiveDirectory' -ListAvailable).Count -ge 1) {
    $splat = @{}

    $password = New-RandomPassword $settings.'Password Length' -AsSecureString
    $params = 'GivenName','Surname','Name','SamAccountName','UserPrincipalName'
    foreach ($param in $params) {
        if ($($settings.$param).Length -gt 0) {
            $splat[$param] = $settings.$param
        }
    }
    
    $newAdUser = New-AdUser @splat -Confirm:$false -PassThru -ErrorAction Stop
    if ($null -ne $newAdUser) {
        Start-Sleep -Seconds 5
        Set-ADAccountPassword $newAdUser.SamAccountName -NewPassword $Password -Reset
        Enable-ADAccount $newAdUser.SamAccountName
        if ($settings.'Change Password At Logon'.ToString() -eq 'true') {
            Set-ADUser $newAdUser.SamAccountName -ChangePasswordAtLogon $true
        } else {
            Set-ADUser $newAdUser.SamAccountName -ChangePasswordAtLogon $false
        }
        Write-Host "Password: $([pscredential]::new('blah',$password).GetNetworkCredential().password)"
    }
} else {
    Write-Host 'ActiveDirectory module is not installed.'
}