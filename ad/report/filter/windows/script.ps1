Write-Host 'Running Filter Report'

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

# regex to remove illegal file name chars from the filter.
$regex = "$(([System.IO.Path]::GetInvalidFileNameChars() | %{[regex]::Escape($_)}) -join '|')"

Get-ChildItem -Filter "$($settings.'Report to Filter').*" | ?{$_.Extension -match '\.json|\.csv'} %{
    Write-Host "Filtering: '$_'"
    foreach ($filter in $settings.'Filters'.Split(',')) {
        Write-Host "Applying filter: '$filter'"
        $name = $filter -replace $regex,''
        $result = $_ | ? ([scriptblock]::Create($filter))
        if ($settings.'CSV Out'.ToString() -eq 'true') {
            $result | Export-Csv ".\results\$name.csv"
        } else {
            $result | ConvertTo-Json | Out-File ".\results\$name.json"
        }
    }
}

Get-ChildItem .\ -Filter *.csv | %{
    Write-Host "Compiling $($_.Name)"
    Import-Csv $_.FullName | Export-Excel $path -WorksheetName $_.BaseName -TableName $_.BaseName -AutoSize
}