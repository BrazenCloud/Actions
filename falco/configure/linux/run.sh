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

start=0
# if falco is running, stop it
if pgrep -x "falco" >/dev/null; then
    systemctl stop falco
    start="1"
fi

if [ -f /etc/falco/falco.yaml ]; then
    echo "$config" > /etc/falco/falco.yaml
else
    echo "Unable to update Falco config. Path does not exist: /etc/falco/falco.yaml"
fi

# if falco was stopped, start it back up
if [ $start == 1 ]; then
    systemctl start falco
fi