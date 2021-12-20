param ([Parameter(Mandatory)]$proc_id)

$Success = $True
$Message = ""
$File    = "" 

# create Procdump directory
$test = & New-Item -Path "." -Name "Procdump" -ItemType "directory" | ConvertTo-json
# verify directory Procdump was created
$jsonObj = $test | ConvertFrom-Json
if ($jsonObj.Exists) {
    # download procdump.zip
    Invoke-WebRequest http://download.sysinternals.com/files/Procdump.zip -OutFile procdump.zip
    # verify procdump.zip was downloaded
    if (Test-Path -Path procdump.zip -PathType Leaf) {
        # unzip procdump file
        Expand-Archive -Path procdump.zip -DestinationPath Procdump
        # run procdump for the process
        $File = "Procdump\$proc_id-memory-dump.dmp"
        $process= Procdump\procdump.exe -accepteula -ma $proc_id $File
        if ( -not ( Test-Path -Path $File -PathType Leaf ) ) {
            $Message = "Unable to create $proc_id-memory-dump.dmp in directory Procdump."
            $Success = $False
        } else {
            $Message = "File $proc_id-memory-dump.dmp created in directory Procdump."
        }
    } else {
            $Message = "Unable to create $proc_id-memory-dump.dmp in directory Procdump, procdump.zip not successfully downloaded."
            $Success = $False
    }
} else {
    $Message = "Unable to create $proc_id-memory-dump.dmp in directory Procdump, unable to create directory Procdump."
    $Success = $False
}

$Output = Select-Object @{n='proc_id';e={$proc_id}},@{n='File';e={$File}},@{n='Successful';e={$Success}},@{n='Message';e={$Message}} -InputObject '' | ConvertTo-json
Write-Host($Output)