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

filePath=$(jq -r '."File Path"' ./settings.json)

# download the results file
mkdir ./out
../../../runway -N -S $host download --directory ./out
cd ./out

# expand each of them
for zip in *.zip; do
    unzip $zip
done

for file in *; do
    echo "Copying $file to $filePath"
    mv $file $filePath
done