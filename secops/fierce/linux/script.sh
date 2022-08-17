#!/bin/bash
cd "${0%/*}"

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

# check if pip is installed
if ! [ -x "$(command -v pip)" ]; then
    echo "Installing pip"

    # check for sudo, install
    if [ -x "$(command -v sudo)" ]; then
        sudo $pman install pip -y
    else
        $pman install pip -y
    fi
else
    echo "pip already installed"
fi

pip install fierce > /dev/null

Targettoscan=$(jq -r '."Target to scan"' ../settings.json)
WideMode=$(jq -r '."Wide Mode"' ../settings.json)
CustomParameters=$(jq -r '."Custom Parameters"' ../settings.json)

declare -a arr

if [ ! -z "$CustomParameters" ]; then
    fierce $CustomParameters
elif [ ! -z "$Targettoscan" ] || [[ ${WideMode} == "true" ]] ; then
    if [ ! -z "$Targettoscan" ] ; then
        arr+=("--domain $Targettoscan --connect")
    fi
    if [[ ${WideMode} == "true" ]] ; then
        arr+=("--wide")
    fi
    fierce ${arr[*]}
else
    fierce
fi
