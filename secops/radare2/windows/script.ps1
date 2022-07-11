$settings = Get-Content .\settings.json | ConvertFrom-Json

$command = ".\windows\radare2.exe $($settings.Parameters)"

if ($settings.'Add Strings Output'.ToString() -eq 'true') {
    $command = "$command -qc izz"
}

if ($settings.'Output as json'.ToString() -eq 'true') {
    $commandsplit = $command.Split(' ')
    for ($x = 0; $x -lt $commandsplit.count; $x++) {
        if ($commandsplit[$x].Trim() -eq '-qc') {
            if ($commandsplit[$x + 1] -notlike '*j') {
                $commandsplit[$x + 1] = "$($commandsplit[$x+1])j"
            }
        }
    }
    $command = $commandsplit -join ' '
}

if (Test-Path $settings.'Scanned file filename and path') {
    $path = (Resolve-Path $settings.'Scanned file filename and path').Path
    $sb = [scriptblock]::Create("$command '$path'")

    Write-Host "Running command: $sb"
    if ($settings.'Output as json'.ToString() -eq 'true') {
        Invoke-Command $sb | Tee-Object -FilePath .\results\radare2_output.json
    } else {
        Invoke-Command $sb | Tee-Object -FilePath .\results\radare2_output.txt
    }
} else {
    Throw "'$($settings.'Scanned file filename and path')' is not a valid path."
}