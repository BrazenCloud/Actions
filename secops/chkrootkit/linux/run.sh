#!/bin/sh
cd "${0%/*}"

REQUIRED_PKGS="jq apt-utils binutils"
PKGS_OK=$(dpkg-query -W --showformat='${Status}\n' $REQUIRED_PKGS|grep "install ok installed")
echo Checking for $REQUIRED_PKGS: $PKGS_OK
if [ "" = "$PKGS_OK" ]; then
  echo "No $REQUIRED_PKGS. Setting up $REQUIRED_PKGS."
  sudo apt-get --yes install $REQUIRED_PKGS
  apt-get --yes install $REQUIRED_PKGS
  apt-get --yes install --fix-missing
fi

params=$(jq -r '."Parameters"' ../settings.json)
chmod +X chkrootkit
sh ./chkrootkit $params >> ../results/chkrootkit.txt