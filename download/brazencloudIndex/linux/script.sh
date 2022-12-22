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

# check if unzip is installed
if ! [ -x "$(command -v unzip)" ]; then
    echo "Installing unzip"
    # check for sudo, install
    if [ -x "$(command -v sudo)" ]; then
        sudo $pman install unzip -y
    else
        $pman install unzip -y
    fi
else
    echo "unzip already installed"
fi

# check if curl is installed
if ! [ -x "$(command -v curl)" ]; then
    echo "Installing curl"
    # check for sudo, install
    if [ -x "$(command -v sudo)" ]; then
        sudo $pman install curl -y
    else
        $pman install curl -y
    fi
else
    echo "curl already installed"
fi

indexName=$(jq -r '."Index Name"' ./settings.json)
clearIndex=$(jq -r '."Clear Index"' ./settings.json)
atoken=$(jq -r '."atoken"' ./settings.json)
host=$(jq -r '."host"' ./settings.json)
jobId=$(jq -r '."job_id"' ./settings.json)

if [ $indexName == '{jobid}' ]; then
    indexName=$jobId
fi

# auth runner
head=$(curl -I -X POST -H "Authorization:Daemon $atoken" "${host}/api/v2/auth/ping")
echo "$head"
auth=$(echo "$head" | grep authorization | cut -d ' ' -f 3)

if [[ -z "$auth" ]]; then
    echo "Unable to auth to BrazenCloud"
    exit 1
fi

# download the results file
mkdir ./out
../../../runway -N -S $host download --directory ./out
cd ./out

# expand each of them
for zip in *.zip; do
    unzip $zip
done

# get group
group=$(curl -H "Authorization:Session $auth" -H "accept:application/json" -H "content-type:application-json" "$host/api/v2/jobs/parent-group/$jobId" )

# if clear, clear index first
if [ "$clearIndex" == 'true' ]; then
    curl -X Delete -H "Authorization:Session $auth" \
        -H "accept:application/json" -H "content-type:application-json" \
        -d "{\"deleteQuery\":{\"query\":{\"match_all\":{}}},\"groupId\": \"$group\"}" \
        "$host/api/v2/datastore/$indexName/delete"
fi

# upload each json
for file in *; do
    if [[ $file == *.zip ]]; then
        continue
    fi
    echo "uploading file: $file"
    # load file
    value=$(sudo sed -e 's/\}$/\},/' $file)
    curl -X POST -H "Authorization:Session $auth" \
        -H "accept:application/json" -H "content-type:application/json" \
        -d "[${value%?}]" \
        "$host/api/v2/datastore/$indexName/$group"
done