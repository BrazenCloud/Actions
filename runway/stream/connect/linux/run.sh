#!/bin/bash
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

streamName=$(jq -r '."Stream Name"' ./settings.json)
outputType=$(jq -r '."Output Type"' ./settings.json)
address=$(jq -r '."Address"' ./settings.json)
timeout=$(jq -r '."Timeout"' ./settings.json)
host=$(jq -r '."Host"' ./settings.json)

echo "Creating a $streamName stream of type '$outputType' connect to $address"

../../../runway -N -S $host stream --connect $streamName --output "$outputType://$address" --persistent