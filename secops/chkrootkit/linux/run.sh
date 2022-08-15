#!/bin/sh
  
cd "${0%/*}"

# check if jq is installed
if ! [ -x "$(command -v jq)" ]; then
    echo "Installing jq"

    # check for sudo, install
    if [ -x "$(command -v sudo)" ]; then
        sudo apt-get install jq -y
    else
        apt-get install jq -y
    fi
else
    echo "jq already installed"
fi

# check if strings is installed
if ! [ -x "$(command -v strings)" ]; then
    echo "Installing binutils"

    # check for sudo, install
    if [ -x "$(command -v sudo)" ]; then
        sudo apt-get install binutils -y
    else
        apt-get install binutils -y
    fi
else
    echo "binutils already installed"
fi

params=$(jq -r '."Parameters"' ../settings.json)
chmod +x chkrootkit
bash ./chkrootkit $params >> ../results/chkrootkit.txt