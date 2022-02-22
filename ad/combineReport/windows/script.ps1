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

if (-not (Get-Module ImportExcel -ListAvailable)) {
    Install-Module ImportExcel -Repository PSGallery -Confirm:$false -Force
}

$path = '.\results\FullReport.xlsx'

Get-ActionResults -ThreadId $settings.'thread_id' -DestinationPath .\ -Extract -ActionRootPath (Get-Location).Path
Get-ChildItem .\ -Filter *.csv | %{
    Import-Csv $_.FullName | Export-Excel $path -WorksheetName $_.Name -TableName $_.Name -AutoSize
}