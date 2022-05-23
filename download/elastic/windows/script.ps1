$settings = Get-Content .\settings.json | ConvertFrom-Json
$settings

$outFolder = '.\out'
if (-not (Test-Path $outFolder)) {
    New-Item $outFolder -ItemType Directory
}
& .\windows\runway.exe -N -S $settings.host download --directory $outFolder

$zips = Get-ChildItem $outFolder -Filter *.zip -Recurse -Verbose
$zips | ForEach-Object {
    Expand-Archive $_.fullName -DestinationPath $outFolder
}

$headers = @{
    'Content-Type' = 'application/json'
}

if ($settings.Authorization.length -gt 1) {
    $headers['Authorization'] = if ($settings.'Is User Authentication') {
        "Basic $([System.Convert]::ToBase64String([System.Text.Encoding]::UTF8.GetBytes($settings.Authorization)))"
    } else {
        "ApiKey $([System.Convert]::ToBase64String([System.Text.Encoding]::UTF8.GetBytes($settings.Authorization)))"
    }
}

$protocol = if ($settings.https.ToString() -eq 'true') {
    "https://"
} else {
    "http://"
}

$postUri = "$protocol$($settings.'Server and Port')/$($settings.'Index Name')/_doc?pretty"

Get-ChildItem $outFolder -Filter *.json | ForEach-Object {
    $irmSplat = @{
        Uri     = $postUri
        Method  = 'Post'
        Headers = $headers
        Body    = Get-Content $_.FullName
    }

    if ($settings.'Skip Cert Check'.ToString() -eq 'true') {
        $irmSplat['SkipCertificateCheck'] = $true
    }

    Invoke-RestMethod @irmSplat
}