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


pip install -r requirements.txt > /dev/null
chmod +x tih.py

## Examples
# Hosttoscan=$(jq -r '."Host to scan"' ../settings.json)
# SkipHealthCheck=$(jq -r '."Skip Health Check"' ../settings.json)
# CustomParameters=$(jq -r '."Custom Parameters"' ../settings.json)
Hash=$(jq -r '."Hash"' ../settings.json)
URL=$(jq -r '."URL"' ../settings.json)

if [ ! -z "$Hash" ]; then
    tih.py -md5 $Hash >> ../results/$Hash.txt;
    fi

    if [ ! -z "$URL" ] ; then
    tih.py -url $URL >> ../results/$URL.txt;
    fi

    if [ ! -z "$IPADDRESS" ] ; then
    tih.py -ip $IPADDRESS >> ../results/$IPADDRESS.txt;
    fi



