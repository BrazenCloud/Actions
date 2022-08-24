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
fi # check if nmap is installed
if ! [ -x "$(command -v nmap)" ]; then
    echo "Installing nmap"

    # check for sudo, install
    if [ -x "$(command -v sudo)" ]; then
        sudo $pman install nmap -y
    else
        $pman install nmap -y
    fi
else
    echo "nmap already installed"
fi # check if openssl is installed
if ! [ -x "$(command -v openssl)" ]; then
    echo "Installing openssl"

    # check for sudo, install
    if [ -x "$(command -v sudo)" ]; then
        sudo $pman install openssl -y
    else
        $pman install openssl -y
    fi
else
    echo "openssl already installed"
fi

pip install raccoon-scanner > /dev/null

Hosttoscan=$(jq -r '."Host to scan"' ../settings.json)
SkipHealthCheck=$(jq -r '."Skip Health Check"' ../settings.json)
CustomParameters=$(jq -r '."Custom Parameters"' ../settings.json)

declare -a arr

if [ ! -z "$CustomParameters" ]; then
    raccoon $CustomParameters
elif [ ! -z "$Hosttoscan" ] || [[ ${SkipHealthCheck} == "true" ]] ; then
    if [ ! -z "$Hosttoscan" ] ; then
        arr+=("-f $Hosttoscan --outdir ../results/$Hosttoscan")
    fi
    if [[ ${SkipHealthCheck} == "true" ]] ; then
        arr+=("--skip-health-check")
    fi
    raccoon ${arr[*]}
else
    raccoon
fi
