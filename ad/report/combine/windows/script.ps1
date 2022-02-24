Write-Host 'Running CombineReport'

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
                Expand-Archive $_.FullName -DestinationPath $DestinationPath -Force:$($Force.IsPresent) -ErrorAction SilentlyContinue
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

if (-not (Get-Module ImportExcel -ListAvailable)) {
    $v = (Get-PackageProvider -Name NuGet -ListAvailable -ErrorAction SilentlyContinue).Version
    if ($null -eq $v -or $v -lt 2.8.5.201) {
        Write-Host 'Updating NuGet...'
        Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Confirm:$false -Force -Verbose
    }
    Write-Host 'Installing ImportExcel...'
    Install-Module ImportExcel -Repository PSGallery -Confirm:$false -Force -Verbose -Scope CurrentUser
}

$path = '.\results\FullReport.xlsx'

Write-Host 'Finding previous results...'
Get-ActionResults -ThreadId $settings.'thread_id' -DestinationPath .\ -Extract -ActionRootPath (Get-Location).Path
Get-ChildItem .\ -Filter *.csv | %{
    Write-Host "Compiling $($_.Name)"
    $eName = ($_.BaseName -replace '[^a-zA-Z\-_]','').TrimStart('_')
    Import-Csv $_.FullName | Export-Excel $path -WorksheetName $eName -TableName $eName -AutoSize
}