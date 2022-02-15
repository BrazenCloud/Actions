$manifests = Get-ChildItem manifest.txt -Recurse
$baseDir = Get-Item ./
foreach ($manifest in $manifests) {
    $repoJsonPath = "$($manifest.Directory.FullName)\repository.json"
    if (-not (Test-Path $repoJsonPath)) {
        New-Item $repoJsonPath -ItemType File
        @"
{
    "Description": "",
    "Language": "",
    "Tags": []
}
"@
    }
    $rPath = $manifest.FullName.Replace($baseDir.FullName,'').Trim('\/')
    $actionName = ($rPath -split '\\|\/' | Select-Object -SkipLast 1) -join ':'

    $repoJson = Get-Content $repoJsonPath | ConvertFrom-Json
    if ((Get-Content $manifest -Raw) -match '\nRUN_WIN' -and $repoJson.Tags -notcontains 'Windows') {
        $repoJson.Tags += 'Windows'
    }
    if ((Get-Content $manifest -Raw) -match '\nRUN_LIN' -and $repoJson.Tags -notcontains 'Linux') {
        $repoJson.Tags += 'Linux'
    }
    $repoJson | ConvertTo-Json | Out-File $repoJsonPath -NoNewline
}