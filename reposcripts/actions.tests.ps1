Describe 'Runway Actions' {
    $manifests = Get-ChildItem manifest.txt -Recurse
    $baseDir = Get-Item ./
    foreach ($manifest in $manifests) {
        $rPath = $manifest.FullName.Replace($baseDir.FullName,'').Trim('\/')
        $actionName = ($rPath -split '\\|\/' | Select-Object -SkipLast 1) -join ':'
        Context $actionName {
            # if RUN_WIN, should have a windows folder
            if ((Get-Content $manifest -Raw) -match '\nRUN_WIN') {
                It 'Should have a windows directory' {
                    Test-Path "$($manifest.Directory.FullName)\windows" -PathType Container | Should -be $true
                }
            }
            # if RUN_LIN, should have a linux folder
            if ((Get-Content $manifest -Raw) -match '\nRUN_LIN') {
                It 'Should have a windows directory' {
                    Test-Path "$($manifest.Directory.FullName)\linux" -PathType Container | Should -be $true
                }
            }
            # Should have a repository
            It 'Should have a repsitory.json file' {
                Test-Path "$($manifest.Directory.FullName)\repository.json" -PathType Leaf | Should -be $true
            }
            It 'Should have a non-empty repsitory.json file' {
                (Get-Item "$($manifest.Directory.FullName)\repository.json" -ErrorAction SilentlyContinue).Length | Should -BeGreaterThan 0
            }
        }
    }
}