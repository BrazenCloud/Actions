$baseDir = Get-Item .\
$manifests = Get-ChildItem .\ -Filter manifest.txt -Recurse
$actions = foreach ($manifest in $manifests) {
    $rPath = $manifest.FullName.Replace($baseDir.FullName,'').Trim('\/')
    [pscustomobject]@{
        Name = ($rPath -split '\\|\/' | Select-Object -SkipLast 1) -join ':'
        RelativePath = $rPath.Replace('\manifest.txt','')
        Parent = $rPath.Split('\')[0]
    }
}

$newContent = foreach ($parent in $actions.Parent | Select -Unique) {
    "- $parent"
    foreach ($action in $actions | ?{$_.Parent -eq $parent}) {
        "  - [$($action.Name)]($($action.RelativePath.Replace('\','/')))"
    }
}


$preLines = if (Test-Path .\README.md) {
    $content = Get-Content .\README.md
    $capture = $true
    :lines foreach ($line in $content) {
        if ($line -like '<!-- region *') {
            break lines
        } elseif ($capture) {
            $line
        }
    }
}

$postLines = if (Test-Path .\README.md) {
    $content = Get-Content .\README.md
    $capture = $false
    :lines foreach ($line in $content) {
        if ($line -like '<!-- endregion -->*') {
            $capture = $true
        } elseif ($capture) {
            $line
        }
    }
}

Remove-Item .\README.md
if ($null -ne $preLines) {
    $preLines | Out-File .\README.md -Append
}
'<!-- region Generated -->' | Out-File .\README.md -Append
$newContent | Out-File .\README.md -Append
'<!-- endregion -->' | Out-File .\README.md -Append
if ($null -ne $postLines) {
    $postLines | Out-File .\README.md -Append
}