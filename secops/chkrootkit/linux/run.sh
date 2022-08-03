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

if [[ $(ls -l /bin/sh| grep 'dash') = *dash* ]]; then
  sudo mv /bin/sh /bin/sh.orig
  mv /bin/sh /bin/sh.orig
  sudo ln -s /bin/bash /bin/sh
  ln -s /bin/bash /bin/sh
fi

params=$(jq -r '."Parameters"' ../settings.json)
chmod +X chkrootkit
./chkrootkit $params >> ../results/chkrootkit.txt