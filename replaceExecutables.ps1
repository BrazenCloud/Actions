$dlPrefix = 'https://runwaydownloads.blob.core.windows.net/appdl/'

# Replace all Pythons with their proper replacements
foreach ($py in (Get-ChildItem .\ -Filter .py* -File -Recurse)) {
    Write-Host '-----------------'
    switch ($py.Directory.Name.ToLower()) {
        'windows' {
            $execName = "$($py.Name.Replace('.','')).exe"
            $destName = 'py.exe'
        }
        'linux' {
            $execName = "$($py.Name.Replace('.',''))"
            $destName = 'python'
        }
    }
    if (-not (Test-Path .\$execName)) {
        Write-Host "Downloading '$execName'..."
        Invoke-WebRequest -Uri "$dlPrefix$execName" -OutFile .\$execName
    }
    Write-Host "Adding '$execName' to '$($py.Directory.FullName)'"
    Copy-Item .\$execName -Destination "$($py.Directory.FullName)\$destName"
    Remove-Item $py.FullName -Force
}

# Replace all .runway with the latest Runway utility executable
foreach ($rw in (Get-ChildItem .\ -Filter .runway -File -Recurse)) {
    Write-Host '-----------------'
    switch ($py.Directory.Name.ToLower()) {
        'windows' {
            $execName = 'runway.exe'
        }
        'linux' {
            $execName = 'runway.bin'
        }
    }
    if (-not (Test-Path .\$execName)) {
        Write-Host "Downloading '$execName'..."
        Invoke-WebRequest -Uri "$dlPrefix$execName" -OutFile .\$execName
    }
    Write-Host "Adding '$execName' to '$($rw.Directory.FullName)'"
    Copy-Item .\$execName -Destination "$($rw.Directory.FullName)\$execName"
    Remove-Item $rw.FullName -Force
}

# Any other executables
foreach ($exec in (Get-ChildItem .\* -Filter .* -File -Recurse | ?{$_.Name -notlike '.py*' -and $_.Name -ne '.runway' -and $_.Name -ne '.gitignore'})) {
    Write-Host '-----------------'
    $execName = $exec.Name.Substring(1)
    if (-not (Test-Path .\$execName)) {
        Write-Host "Downloading '$execName'..."
        Invoke-WebRequest -Uri "$dlPrefix$execName" -OutFile .\$execName
    }
    Write-Host "Adding '$execName' to '$($exec.Directory.FullName)'"
    Copy-Item .\$execName -Destination "$($exec.Directory.FullName)\$execName"
    Remove-Item $exec.FullName -Force
}