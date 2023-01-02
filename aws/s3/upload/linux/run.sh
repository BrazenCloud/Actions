#!/bin/bash

# check for current package manager
declare -A osInfo;
osInfo[/etc/redhat-release]=yum
osInfo[/etc/arch-release]=pacman
osInfo[/etc/gentoo-release]=emerge
osInfo[/etc/SuSE-release]=zypp
osInfo[/etc/debian_version]=apt-get
osInfo[/etc/alpine-release]=apk

for f in ${!osInfo[@]}
do
    if [[ -f $f ]];then
        #echo Package manager: ${osInfo[$f]}
        pman=${osInfo[$f]}
    fi
done

# check if jq is installed
if ! [ -x "$(command -v jq)" ]; then
    echo "Installing jq"

    # check for sudo, install
    if [ -x "$(command -v sudo)" ]; then
        sudo $pman install jq -y
    else
        $pman install jq -y
    fi
else
    echo "jq already installed"
fi

# check if unzip is installed
if ! [ -x "$(command -v unzip)" ]; then
    echo "Installing unzip"
    # check for sudo, install
    if [ -x "$(command -v sudo)" ]; then
        sudo $pman install unzip -y
    else
        $pman install unzip -y
    fi
else
    echo "unzip already installed"
fi

bucketName=$(jq -r '."Bucket Name"' ./settings.json)
s3BasePath=$(jq -r '."Path"' ./settings.json)
accessKey=$(jq -r '."Access Key"' ./settings.json)
secretKey=$(jq -r '."Secret Key"' ./settings.json)
host=$(jq -r '."host"' ./settings.json)

# same for all
contentType="application/x-compressed-tar"

# download the results file
mkdir ./out
cd ./out
../../../runway -N -S $host download
ls -al

# expand each of them
for zip in *.zip; do
    unzip $zip
done

for file in *; do
    echo "Uploading $file to S3"
    #mv $file $filePath
    # dest path
    s3Path="/${bucketName}${s3BasePath}${file}"

    # metadata
    dateValue=`date -R`
    signatureString="PUT\n\n${contentType}\n${dateValue}\n${s3Path}"

    #prepare signature hash to be sent in Authorization header
    signatureHash=`echo -en ${signatureString} | openssl sha1 -hmac ${secretKey} -binary | base64`

    # actual curl command to do PUT operation on s3
    curl -X PUT -T "${file}" \
    -H "Host: ${bucketName}.s3.amazonaws.com" \
    -H "Date: ${dateValue}" \
    -H "Content-Type: ${contentType}" \
    -H "Authorization: AWS ${accessKey}:${signatureHash}" \
    https://${bucketName}.s3.amazonaws.com/${file}
done