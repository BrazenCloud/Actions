#!/bin/sh

cd "${0%/*}"

REQUIRED_PKGS="jq apt-utils binutils"
PKG_OK=$(dpkg-query -W --showformat='${Status}\n' $REQUIRED_PKGS|grep "install ok installed")
echo Checking for $REQUIRED_PKGS: $PKGS_OK
if [ "" = "$PKGS_OK" ]; then
  echo "No $REQUIRED_PKGS. Setting up $REQUIRED_PKGS."
  sudo apt-get --yes install $REQUIRED_PKGS 
  apt-get --yes install $REQUIRED_PKGS
fi

params=$(jq -r '."Parameters"' ../settings.json)
chmod +x ./chkrootkit.sh
./chkrootkit.sh $params >> ../results/chkrootkit.txt