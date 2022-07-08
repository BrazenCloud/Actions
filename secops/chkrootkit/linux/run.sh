#!/bin/sh

cd "${0%/*}"

sudo apt-get install jq -y
apt-get install jq -y

params=$(jq -r '."Parameters"' ../settings.json)

./chkrootkit $params