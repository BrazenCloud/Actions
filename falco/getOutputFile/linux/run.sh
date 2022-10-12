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

jsonOutParam=$(jq -r '."JSON Only"' ./settings.json)
deleteFile=$(jq -r '."Delete file"' ./settings.json)

falcoPath='/etc/falco/falco.yaml'

# is file output enabled?
# first, get the file_output: header
lineNum=$(grep -n 'file_output:' $falcoPath | cut -d ':' -f 1)
((lineNum=lineNum+1))
line=$(sed -n "$lineNum"p $falcoPath)

# check the next line until enabled is found
# or a line is found that isn't '  something'
regex="^\s\s(keep\_alive|filename)"
while [[ $line =~ $regex ]]; do
    echo $lineNum
    ((lineNum=lineNum+1))
    line=$(sed -n "$lineNum"p $falcoPath)
done
line=$(sed -n "$lineNum"p $falcoPath)

# then check if enabled: true
if [[ "$line" =~ "enabled" ]]; then
    fileEnabled=$(echo $line | cut -d ':' -f 2 | xargs)
    if [[ $fileEnabled =~ 'true' ]]; then
        echo "File output enabled, can continue."
    else
        echo "File output is not enabled, cannot continue."
        echo "Other output methods are not yet supported."
        exit 1
    fi
else
    echo "Unable to check if file output is enabled."
    exit 1
fi

# then check if enabled: true
if [ "$jsonOutParam" == 'true' ]; then
    # is json output enabled?
    jsonEnabled=$(grep "json_output" $falcoPath | cut -d ':' -f 2 | xargs)
    if [[ $jsonEnabled =~ 'true' ]]; then
        echo "Json output enabled, can continue."
    else
        echo "Json output is not enabled, cannot continue."
        echo "When JSON output is requested, Falco must also"
        echo "have JSON output enabled."
        exit 1
    fi
fi

# get file path
# first, get the file_output: header
lineNum=$(grep -n 'file_output:' $falcoPath | cut -d ':' -f 1)
((lineNum=lineNum+1))
line=$(sed -n "$lineNum"p $falcoPath)

# check the next line until filename is found
# or a line is found that isn't '  something'
regex="^\s\s(keep\_alive|enabled)"
while [[ $line =~ $regex ]]; do
    ((lineNum=lineNum+1))
    line=$(sed -n "$lineNum"p $falcoPath)
done
line=$(sed -n "$lineNum"p $falcoPath)

# then get the path from the line
# then check if enabled: true
if [[ $line =~ filename ]]; then
    logPath=$(echo $line | cut -d ':' -f 2 | xargs | tr -d '\r')
    echo "filename: $logPath"
else
    echo "No filename found."
    exit 1
fi

# get file
if [ "$deleteFile" == 'true' ]; then
    mv "$logPath" ./results
else
    cp "$logPath" ./results
fi