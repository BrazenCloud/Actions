Write-Host 'Running Group Report'

Function Get-ActionResults {
    param (
        [Parameter(Mandatory)]
        [string]$ThreadId,
        [string]$ActionRootPath,
        [switch]$Extract,
        [Parameter(Mandatory)]
        [string]$DestinationPath,
        [switch]$Force
    )
    $resultCache = "$(($ActionRootPath -split 'work_tree')[0])\result_cache\$ThreadId"
    if (Test-Path $resultCache) {
        Get-ChildItem $resultCache -Recurse -Filter *.zip | Foreach-Object {
            if ($Extract.IsPresent) {
                Expand-Archive $_.FullName -DestinationPath $DestinationPath -Force:$($Force.IsPresent)
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

Write-Host 'Finding previous results...'
Get-ActionResults -ThreadId $settings.'thread_id' -DestinationPath .\ -Extract -ActionRootPath (Get-Location).Path

Get-ChildItem -Filter "$($settings.'Report to Group').*" | ?{$_.Extension -match '\.json|\.csv'} | %{
    Write-Host "Grouping: '$_'"
    foreach ($prop in $settings.'Properties to Group'.Split(',')) {
        Write-Host "Applying Group: '$prop'"
        if ($_.Extension -eq '.csv') {
            $result = Import-Csv $_.FullName | Group $prop | Select Name,Count
        } elseif ($_.Extension -eq '.json') {
            $result = Get-Content $_.FullName | ConvertFrom-Json | Group $prop | Select Name,Count
        }
        if ($settings.'CSV Out'.ToString() -eq 'true') {
            $result | Export-Csv ".\results\$prop.csv"
        } else {
            $result | ConvertTo-Json | Out-File ".\results\$prop.json"
        }
    }
}