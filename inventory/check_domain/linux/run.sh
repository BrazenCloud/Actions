#!/bin/sh

cd "${0%/*}"

pythonCMD="python"

if ! [ -x "$(command -v python)" ]; then
    # no python installed
    pythonCMD="./python_3.7"
    chmod +x $pythonCMD 
fi

# Install prerequisite python tools
apt-get install python3 -y
sudo apt-get install python3 -y
apt install python3 -y
sudo apt install python3 -y
apt-get install jq -y
apt-get install pip -y
sudp apt-get install pip -y
apt install pip -y
sudo apt install pip -y
apt-get upgrade --fix-missing


# Install prerequisite pip required modules
pip install -r requirements.txt

#set executable permission
chmod +x check_domain.py

domaintoscan1=$(jq -r '."Domain"' ../settings.json)
selector1=$(jq -r '."SELECTOR_DKIM"' ../settings.json)
selector2=$(jq -r '."SELECTOR_BMI"' ../settings.json)
verbose1=$(jq -r '."Verbose"' ../settings.json)

$pythonCMD check_domain.py $domaintoscan1 $selector1 $selector2 $verbose1 >> ../results/check_domain.txt

