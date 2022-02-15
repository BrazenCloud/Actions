# Template location
$tReadme = '.\reposcripts\action-README-template.md'

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
        $repositoryContents = Get-Content $path\repository.json | ConvertFrom-Json -AsHashtable
        foreach ($value in $repositoryValues) {
            if ($repositoryContents.Keys -contains $value) {
                $replace[$value] = $repositoryContents[$value]
            }
        }
    }

    enum RunwayParamTypes {
        String = 0
        Number = 1
        Boolean = 2
    }

    if (Test-Path $path\parameters.json) {
        $parameters = Get-Content $path\parameters.json | ConvertFrom-Json -AsHashtable
        $replace['Parameters'] = foreach ($param in $parameters) {
            "- $($param['Name'])"
            if ($param.Keys -contains 'Description') {
                "  - Description: $($param['Description'])"
            }
            "  - Type: $([RunwayParamTypes]$param['Type'])"
            if ($param.Keys -contains 'IsOptional') {
                "  - IsOptional: $($param['IsOptional'])"
            }
            if ($param.Keys -contains 'DefaultValue') {
                "  - DefaultValue: $($param['DefaultValue'])"
            }
        }
        $replace['Parameters'] = $replace['Parameters'] -join "`n"
    }

    $replace['operatingsystems'] = @()
    $manifestContents = Get-Content $manifest.FullName
    foreach ($line in $manifestContents) {
        if ($line -like 'RUN_WIN*') {
            $replace['operatingsystems'] += 'Windows'
        } elseif ($line -like 'RUN_LIN*') {
            $replace['operatingsystems'] += 'Linux'
        }
    }

    $tReadmeContent = Get-Content $tReadme
    $tReadmeContent = foreach ($line in $tReadmeContent) {
        if ($line -match '\{([a-zA-Z]+)\}') {
            if ($replace.Keys -contains $Matches.1) {
                if ($replace[$($Matches.1)].GetType().BaseType.Name -eq 'Array') {
                    if (($replace[$($Matches.1)] | ?{$_}).Count -gt 0) {
                        $line -replace '\{([a-zA-Z]+)\}',"$($replace[$($Matches.1)] -join "`n  - ")"
                    } else {
                        $line -replace '\{([a-zA-Z]+)\}',"None specified."
                    }
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

    $extraLines = $null
    if (Test-Path $path\README.md) {
        $content = Get-Content $path\README.md
        $capture = $true
        $extraLines = foreach ($line in $content) {
            if ($line -like '<!-- region *') {
                $capture = $false
            } elseif ($line -like '<!-- endregion -->*') {
                $capture = $true
            } elseif ($capture) {
                $line
            }
        }
    }

    $tReadmeContent | Out-File $path\README.md
    if ($null -ne $extraLines) {
        $extraLines | Out-File $path\README.md -Append
    }
}