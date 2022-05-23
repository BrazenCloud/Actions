BeforeDiscovery {
    $baseDir = Get-Item ./
    $manifests = foreach ($m in (Get-ChildItem manifest.txt -Recurse)) {
        $rPath = $m.FullName.Replace($baseDir.FullName, '').Trim('\/')
        @{
            ActionName = ($rPath -split '\\|\/' | Select-Object -SkipLast 1) -join ':'
            Manifest   = $m
        }
    }
}
Describe 'Runway Actions' {
    Context 'Action: <ActionName>' -Foreach $manifests {
        It "Should have a Windows directory" -Skip:((Get-Content $manifest -Raw) -notmatch '\nRUN_WIN') {
            Test-Path $manifest.FullName | Should -Be $true
        }
        It "Should have a Linux directory" -Skip:((Get-Content $manifest -Raw) -notmatch '\nRUN_LIN') {
            Test-Path $manifest.FullName | Should -Be $true
        }
        It 'Should have a repsitory.json file' {
            Test-Path "$($manifest.Directory.FullName)\repository.json" -PathType Leaf | Should -be $true
        }
        It 'Should have a non-empty repsitory.json file' {
            (Get-Item "$($manifest.Directory.FullName)\repository.json" -ErrorAction SilentlyContinue).Length | Should -BeGreaterThan 0
        }
        BeforeAll {
            $json = Get-Content "$($manifest.Directory.FullName)\repository.json" | ConvertFrom-Json
        }
        It 'The repository.json file should have a description' -Skip:(-not (Test-Path "$($manifest.Directory.FullName)\repository.json" -PathType Leaf)) {
            $json.Description.Length | Should -BeGreaterThan 0
        }
        It 'The repository.json file should have a language' {
            $json.Language.Length | Should -BeGreaterThan 0
        }
        It 'The repository.json file should have tags' {
            $json.Tags.Count | Should -BeGreaterThan 0
        }
    }
}