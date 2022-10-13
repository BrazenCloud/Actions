$settings = Get-Content .\settings.json | ConvertFrom-Json

$interfaces = .\windows\tshark\tshark.exe -D
$interfaces

$interfaceIndexes = $interfaces | ForEach-Object { $_.Split('.')[0] }

if ($interfaceIndexes -contains $settings.'Interface Index'.ToString()) {
    .\windows\tshark\tshark.exe -i $settings.'Interface Index' -w ".\results\$($settings.'Output file')" -a $settings.'Auto Stop Condition' -b $settings.'Buffer'
} else {
    Throw "Interface with index $($settings.'Interface Index') does not exist."
}