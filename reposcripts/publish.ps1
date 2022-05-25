param (
    [switch]$Test,
    [string]$Server = 'portal.runway.host'
)

$baseDir = Get-Item ./
foreach ($manifest in (Get-ChildItem ./ -Filter manifest.txt -Recurse)) {
    
    # Determine namespace based on folder structure
    $rPath = $manifest.FullName.Replace($baseDir.FullName, '').Trim('\/')
    $namespace = ($rPath -split '\\|\/' | Select-Object -SkipLast 1) -join ':'
    Write-Host "----------------------------------------------"
    Write-Host "Found: '$rPath', publishing as '$namespace'..."
    
    # Publish the Action
    if ($Test.IsPresent) {
        ./runway.bin -q -N -S $Server build -i $($manifest.FullName) -o "$($namespace.Replace(':','-')).apt"
    } else {
        & ./runway.bin -q -N -S $Server build -i $($manifest.FullName) -o "$($namespace.Replace(':','-')).apt" -p $($namespace.ToLower()) --PUBLIC
    }
}