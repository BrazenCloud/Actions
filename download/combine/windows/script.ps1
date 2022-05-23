Write-Host "download:combine"
Function Get-ActionResults {
    param (
        [Parameter(Mandatory)]
        [string]$ThreadId,
        [string]$ActionRootPath,
        [switch]$Extract,
        [Parameter(Mandatory)]
        [string]$DestinationPath,
        [switch]$Force,
        [switch]$RenameIfExists
    )
    $resultCache = "$(($ActionRootPath -split 'work_tree')[0])\result_cache\$ThreadId"
    if (Test-Path $resultCache) {
        Get-ChildItem $resultCache -Recurse -Filter *.zip | Foreach-Object {
            if ($Extract.IsPresent) {
                if ($RenameIfExists) {
                    if (-not (Test-Path $DestinationPath\tmp)) {
                        New-Item $DestinationPath\tmp -ItemType Directory | Out-Null
                    }
                    Expand-Archive $_.FullName -DestinationPath $DestinationPath\tmp -Force:$($Force.IsPresent) -ErrorAction SilentlyContinue
                    foreach ($item in Get-ChildItem $DestinationPath\tmp) {
                        $itemName = $item.Name
                        $x = 0
                        While (Test-Path $DestinationPath\$itemName) {
                            $x++
                            $itemName = "$($item.BaseName) ($x)$($item.Extension)"
                        }
                        Copy-Item $item.FullName -Destination $DestinationPath\$itemName
                    }
                } else {
                    Expand-Archive $_.FullName -DestinationPath $DestinationPath -Force:$($Force.IsPresent) -ErrorAction SilentlyContinue
                }
            } else {
                Copy-Item $_.FullName -Destination $DestinationPath -Force:$($Force.IsPresent)
            }
        }
    } else {
        Write-Warning "Unable to find any results in the result_cache."
        Write-Warning "Path: '$resultCache'"
    }
}

$settings = Get-Content .\settings.json | ConvertFrom-Json
$settings

Get-ActionResults -ThreadId $settings.'thread_id' -DestinationPath .\results -Extract -ActionRootPath (Get-Location).Path -RenameIfExists
Get-ChildItem .\results