$settings = Get-Content .\settings.json | ConvertFrom-Json

$contentType = "application/base64"
$contentType = "application/x-compressed-tar"

# download the results file
..\..\..\runway -N -S $settings.host download
Set-Location .\download
Get-ChildItem

foreach ($zip in (Get-ChildItem -Filter *.zip)) {
    Expand-Archive $zip.FullName -DestinationPath .\ -Force
}

# Copy the file to the destination path
Get-ChildItem -Filter *.* | Where-Object { $_.Extension -ne '.zip' } | ForEach-Object {
    Write-Host "Uploading $($_.Name) to S3"
    #mv $file $filePath
    # dest path
    $s3Path = "/$($settings.'Bucket Name')$($settings.'Path')$($_.Name)"

    # metadata
    $date = Get-Date -UFormat '%a, %d %b %Y %H:%M:%S %Z'
    $signatureString = "PUT`n`n$contentType`n$($date)00`n$s3Path"

    #prepare signature hash to be sent in Authorization header
    $hmacsha = New-Object System.Security.Cryptography.HMACSHA1
    $hmacsha.key = [Text.Encoding]::ASCII.GetBytes($settings.'Secret Key')
    $signatureHash = $hmacsha.ComputeHash([Text.Encoding]::ASCII.GetBytes($signatureString))
    $signatureHash = [Convert]::ToBase64String($signatureHash)

    #[System.BitConverter]::ToString($signature1) -replace '-', ''
    #$signatureHash = `echo -en ${signatureString} | openssl sha1 -hmac ${secretKey} -binary | base64`

    # actual curl command to do PUT operation on s3
    #$base64Image = [convert]::ToBase64String((Get-Content $path -Encoding byte))
    #Invoke-WebRequest -Uri $uri -Method Post -Body $base64Image -ContentType "application/base64"
    $splat = @{
        Method  = 'Put'
        #InFile  = 'C:\Users\anthony\Downloads\folder\test.txt' #$_.FullName
        Body    = [convert]::ToBase64String((Get-Content $_.FullName -Encoding byte))
        Uri     = "https://$($settings.'Bucket Name').s3.amazonaws.com/test.txt"
        Headers = @{
            Host           = "$($settings.'Bucket Name').s3.amazonaws.com"
            Date           = "$($date)00"
            'Content-Type' = $contentType
            Authorization  = "AWS $($settings.'Access Key'):$signatureHash"
        }
    }
    Invoke-RestMethod @splat
}