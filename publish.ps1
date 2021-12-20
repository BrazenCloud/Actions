param (
    [switch]$Test
)

$baseDir = Get-Item ./
foreach ($manifest in (Get-ChildItem ./ -Filter manifest.txt -Recurse)) {
    
    # Determine namespace based on folder structure
    $rPath = $manifest.FullName.Replace($baseDir.FullName,'').Trim('\/')
    $namespace = ($rPath -split '\\|\/' | Select-Object -SkipLast 1) -join ':'
    Write-Host "Found: '$rPath', publishing as '$namespace'..."
    

    # Publish the Action
    if ($Test.IsPresent) {
        ./runway.bin -N build -it $manifest.FullName -o $namespace.Replace(':','-')
    } else {
        ./runway.bin -N build -it $manifest.FullName -p $namespace.ToLower() -o $namespace.Replace(':','-')
    }
}