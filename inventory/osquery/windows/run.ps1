# Load settings
$settings = Get-Content .\settings.json | ConvertFrom-Json 

# Debug
$search = $settings.Query
Write-host "Running query: $search"

$queryResults = .\windows\osqueryi.exe "$search" --json

# if formatting for elastic, use the filebeat osquery module format
if ($settings.'Format for Elastic'.ToString() -eq 'true') {
    $out = @{
        osquery = @{
            results = @{
                name           = $settings.'Query Name'
                hostIdentifier = hostname
                CalendarTime   = (Get-Date -UFormat "%a %b %d %T %Y")
                unixTime       = (Get-Date -UFormat %s)
                epoch          = 0
                counter        = 0
                numerics       = $false
                columns        = $queryResults | ConvertFrom-Json
                action         = 'added'
            }
        }
    }
    $out | ConvertTo-Json -Depth 4 | Out-File .\results\osquery.json
} else {
    $queryResults | Out-File .\results\osquery.json
}
