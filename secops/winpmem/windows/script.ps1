Set-Location $PSScriptRoot
$settings = Get-Content ..\settings.json | ConvertFrom-Json



if ( $settings.'Parameters'.ToString().Length -gt 0 ) {
    winpmem_mini_x64_rc2.exe $($settings.'Parameters')
} else {
    winpmem_mini_x64_rc2.exe
}
