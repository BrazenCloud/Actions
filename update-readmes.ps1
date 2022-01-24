# Template location
$tReadme = '.\action-README-template.md'

# Value locations
$repositoryValues = @(
    'Language',
    'Tags',
    'Description'
)

$baseDir = Get-Item .\

#$manifests = gci .\ -filter manifest.txt | Select -First 1
$manifests = gci .\inventory\accounts -Filter manifest.txt
foreach ($manifest in $manifests) {
    $replace = @{}

    $rPath = $manifest.FullName.Replace($baseDir.FullName,'').Trim('\/')
    $replace['name'] = ($rPath -split '\\|\/' | Select-Object -SkipLast 1) -join ':'
    
    $path = Split-Path $manifest.FullName
    $repository = Get-Item $path\repository.json
    if ($null -ne $repository) {
        $repositoryContents = Get-Content $repository.FullName | ConvertFrom-Json -AsHashtable
        foreach ($value in $repositoryValues) {
            if ($repositoryContents.Keys -contains $value) {
                $replace[$value] = $repositoryContents[$value]
            }
        }
    }

    $tReadmeContent = Get-Content $tReadme
    $tReadmeContent = foreach ($line in $tReadmeContent) {
        if ($line -match '\{([a-zA-Z]+)\}') {
            if ($replace[$($Matches.1)].GetType().BaseType.Name -eq 'Array') {
                $line -replace '\{([a-zA-Z]+)\}',"  - $($replace[$($Matches.1)] -join "`n  - ")"
            } else {
                $line -replace '\{([a-zA-Z]+)\}',"$($replace[$($Matches.1)])"
            }
        } else {
            $line
        }
    }

    if (-not (Test-Path $path\README.md)) {
        $tReadmeContent | Out-File $path\README.md
    }
}