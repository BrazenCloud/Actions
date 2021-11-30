
$Success = $True
$Message = ""
$File    = "" 

# create RAMMap directory
$test = & New-Item -Path "." -Name "RAMMap" -ItemType "directory" | ConvertTo-json
# verify directory RAMMap was created
$jsonObj = $test | ConvertFrom-Json
if ($jsonObj.Exists) {
    # download RAMMap.zip
    Invoke-WebRequest https://download.sysinternals.com/files/RAMMap.zip -OutFile RAMMap.zip
    # verify RAMMap.zip was downloaded
    if (Test-Path -Path RAMMap.zip -PathType Leaf) {
        # unzip RAMMap file
        Expand-Archive -Path RAMMap.zip -DestinationPath RAMMap
        # run RAMMap
        $File = "RAMMap\memory-dump.dmp"
        $result = RAMMap\RAMMap.exe -accepteula $File
        if ( -not ( Test-Path -Path $File -PathType Leaf ) ) {
            $Message = "Unable to create memory-dump.dmp in directory RAMMap."
            $Success = $False
        } else {
            $Message = "File memory-dump.dmp created in directory RAMMap."
        }
    } else {
            $Message = "Unable to create memory-dump.dmp in directory RAMMap, RAMMap.zip not successfully downloaded."
            $Success = $False
    }
} else {
    $Message = "Unable to create memory-dump.dmp in directory RAMMap, unable to create directory RAMMap."
    $Success = $False
}

$Output = Select-Object @{n='File';e={$File}},@{n='Successful';e={$Success}},@{n='Message';e={$Message}} -InputObject '' | ConvertTo-json
Write-Host($Output)