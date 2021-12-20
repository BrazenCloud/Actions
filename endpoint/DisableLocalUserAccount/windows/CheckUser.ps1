$IntResults = Get-WmiObject Win32_UserAccount -filter LocalAccount=True | ConvertTo-json
Write-Host($IntResults)
$IntResults | Out-File "users.json"