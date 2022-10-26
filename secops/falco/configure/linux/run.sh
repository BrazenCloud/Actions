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

config=$(jq -r '."Configuration"' ./settings.json)
restartService=$(jq -r '."Restart Service"' ./settings.json)

if [ -f /etc/falco/falco.yaml ]; then
    echo "$config" > /etc/falco/falco.yaml
else
    echo "Unable to update Falco config. Path does not exist: /etc/falco/falco.yaml"
fi

# restart if requested
if [ "$restartService" == 'true' ]; then
    systemctl restart falco
fi