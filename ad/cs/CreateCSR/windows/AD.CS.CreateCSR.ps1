# Import the settings
$settings = Get-Content .\settings.json | ConvertFrom-Json
$settings

if (-not (Get-WindowsFeature ADCS-Cert-Authority).Installed) {
# inf stuff
    $inf = @'
[NewRequest]
Subject = "<subject>"
Exportable = TRUE
RequestType = PKCS10
'@
    if ($settings.'Machine Key Set' -eq $true) {
        $inf += "`nMachineKeySet = true"
    }

    if ($settings.Subject -eq 'Generated') {
        # Find that website (defaults to the default name)
        $website = Get-Website -Name $settings.'Website Name'
        if ($null -ne $website) {
            $sslBinding = $website.Bindings.Collection | Where-Object {$_.Protocol -eq 'https'}
            $subject = $sslBinding.bindingInformation.Split(':')[2]
        } else {
            Throw "Website with name '$($settings.'Website Name')' not found."
        }
    } else {
        $subject = $settings.Subject
    }

    $inf = $inf -replace '\<subject\>',"CN=$subject"
    $inf
    $inf | Out-File .\certreq.inf

    certreq.exe -new .\certreq.inf .\results\cert.req
} else {
    Write-Host 'Action is only meant to run on non-CAs.'
}