#!/bin/sh

cd "${0%/*}"

sudo apt-get install jq -y  > /dev/null
apt-get install jq -y  > /dev/null

params=$(jq -r '."Parameters"' ../settings.json)

./chkrootkit $params