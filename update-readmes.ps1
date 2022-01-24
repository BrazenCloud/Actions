# Template location
$tReadme = '.\action-README-template.md'

# Value locations
$repositoryValues = @(
    'Language',
    'Tags',
    'Description'
)

$baseDir = Get-Item .\

$manifests = Get-ChildItem .\ -Filter manifest.txt -Recurse
foreach ($manifest in $manifests) {
    $replace = @{}

    $rPath = $manifest.FullName.Replace($baseDir.FullName,'').Trim('\/')
    $replace['name'] = ($rPath -split '\\|\/' | Select-Object -SkipLast 1) -join ':'
    
    $path = Split-Path $manifest.FullName
    
    if (Test-Path $path\repository.json) {
        $repository = Get-Item $path\repository.json
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
            if ($replace.Keys -contains $Matches.1) {
                if ($replace[$($Matches.1)].GetType().BaseType.Name -eq 'Array') {
                    $line -replace '\{([a-zA-Z]+)\}',"$($replace[$($Matches.1)] -join "`n  - ")"
                } else {
                    $line -replace '\{([a-zA-Z]+)\}',"$($replace[$($Matches.1)])"
                }
            } else {
                $line -replace '\{([a-zA-Z]+)\}',"None specified."
            }
        } else {
            $line
        }
    }

    if (-not (Test-Path $path\README.md)) {
        $tReadmeContent | Out-File $path\README.md
    }
}