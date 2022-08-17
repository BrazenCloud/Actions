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



# check if debsums is installed
if ! [ -x "$(command -v debsums)" ]; then
    echo "Installing debsums"

    # check for sudo, install
    if [ -x "$(command -v sudo)" ]; then
        sudo $pman install debsums -y
    else
        $pman install debsums -y
    fi
else
    echo "debsums already installed"
fi

Silent=$(jq -r '."Silent"' ../settings.json)
CustomParameters=$(jq -r '."Custom Parameters"' ../settings.json)


if [ ! -z "$CustomParameters" ] ; then
    debsums $CustomParameters >> ../results/out.txt
elif [[ ${Silent} == "true" ]]; then
    debsums -s >> ../results/out.txt
else
    debsums >> ../results/out.txt
fi
