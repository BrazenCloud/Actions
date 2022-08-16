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



# check if binutils is installed
if ! [ -x "$(command -v strings)" ]; then
    echo "Installing binutils"

    # check for sudo, install
    if [ -x "$(command -v sudo)" ]; then
        sudo $pman install binutils -y
    else
        $pman install binutils -y
    fi
else
    echo "binutils already installed"
fi

Parameters=$(jq -r '."Parameters"' ../settings.json)


if [ ! -z "$Parameters" ] ; then
    chkrootkit $Parameters
else
    chkrootkit
fi
