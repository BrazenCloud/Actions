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

rules=$(jq -r '."Rules"' ./settings.json)
rulePath=$(jq -r '."Rule path"' ./settings.json)
replace=$(jq -r '."Replace"' ./settings.json)
loadFirst=$(jq -r '."Load first"' ./settings.json)
restartService=$(jq -r '."Restart Service"' ./settings.json)
listAdd=$(jq -r '."Do not add to rules list"' ./settings.json)

echo "rulePath: $rulePath"
echo "replace: $replace"
echo "loadFirst: $loadFirst"

if [ -f $rulePath ]; then
    echo "rulePath already exists."
    if [ "$replace" == 'true' ]; then
        echo "replacing..."
        echo "$rules" > $rulePath
    else
        echo 'Rule file already exists, cannot continue unless Replace is selected.'
        return 1
    fi
else
    echo "$rules" > $rulePath
fi

falcoPath='/etc/falco/falco.yaml'

if [ "$listAdd" != 'true' ]; then
    if [ "$loadFirst" == 'true' ]; then
        sed "/rules_file:/a\  - $rulePath" $falcoPath --in-place
    else
        # this could probably be done with a smart awk or sed command
        # but doing it this way allows for a load order param that
        # accepts an integer and placess the rule in that specific
        # order.

        # get the line number for 'rules_file:'
        lineNum=$(grep -n 'rules_file:' $falcoPath | cut -d ':' -f 1)
        ((lineNum=lineNum+1))
        # get the line after 'rules_file:'
        line=$(sed -n "$lineNum"p $falcoPath)
        # while that line starts with '  - ', indicating another rule
        # check the next line until a line is found that doesn't
        while [[ $line =~ ^\ \ -\  ]]; do
            ((lineNum=lineNum+1))
            line=$(sed -n "$lineNum"p $falcoPath)
        done
        # append the rule path to the bottom of the list
        sed "${lineNum}i \ \ - $rulePath" $falcoPath --in-place
    fi
fi

if [ "$restartService" == 'true' ]; then
    systemctl restart falco
fi