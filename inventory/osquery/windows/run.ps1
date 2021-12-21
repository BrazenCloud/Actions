
#
# change the CWD to the script directory
#
$scriptpath = $MyInvocation.MyCommand.Path
$dir = Split-Path $scriptpath
#Write-host "My directory is $dir"
Set-Location -Path $dir

#
# read the user configured data from settings
#
$settings = Get-Content ..\settings.json | ConvertFrom-Json 
$search = $settings.Query
Write-host "my search is $search"

.\osqueryi.exe "$search" >> ..\results\query_results.txt
