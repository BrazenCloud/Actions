$settings= Get-Content .\settings.json | ConvertFrom-Json

.\windows\py.exe hosthunter.py -t $settings.hosttoscan -f CSV -o .\results\$($settings.hosttoscan)\results.csv