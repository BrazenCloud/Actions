#!/bin/bash
cd "${0%/*}"

REQUIRED_PKGS1="jq"
PKGS1_OK=$(dpkg-query -W --showformat='${Status}\n' $REQUIRED_PKGS1|grep "install ok installed")
echo Checking for $REQUIRED_PKGS1: $PKGS1_OK
if [ "" = "$PKGS1_OK" ]; then
  echo "No $REQUIRED_PKGS1. Setting up $REQUIRED_PKGS1."
  sudo apt-get --yes install $REQUIRED_PKGS1
  apt-get --yes install $REQUIRED_PKGS1
  apt-get --yes install --fix-missing
fi

REQUIRED_PKGS2="apt-utils"
PKGS2_OK=$(dpkg-query -W --showformat='${Status}\n' $REQUIRED_PKGS2|grep "install ok installed")
echo Checking for $REQUIRED_PKGS2: $PKGS2_OK
if [ "" = "$PKGS2_OK" ]; then
  echo "No $REQUIRED_PKGS2. Setting up $REQUIRED_PKGS2."
  sudo apt-get --yes install $REQUIRED_PKGS2
  apt-get --yes install $REQUIRED_PKGS2
  apt-get --yes install --fix-missing
fi

REQUIRED_PKGS3="binutils"
PKGS_OK=$(dpkg-query -W --showformat='${Status}\n' $REQUIRED_PKGS3|grep "install ok installed")
echo Checking for $REQUIRED_PKGS3: $PKGS3_OK
if [ "" = "$PKGS3_OK" ]; then
  echo "No $REQUIRED_PKGS3. Setting up $REQUIRED_PKGS3."
  sudo apt-get --yes install $REQUIRED_PKGS3
  apt-get --yes install $REQUIRED_PKGS3
  apt-get --yes install --fix-missing
fi

if [[ $(ls -l /bin/sh| grep 'dash') = *dash* ]]; 
then
  echo hi
  sudo mv /bin/sh /bin/sh.orig
  mv /bin/sh /bin/sh.orig
  sudo ln -s /bin/bash /bin/sh
  ln -s /bin/bash /bin/sh
fi

params=$(jq -r '."Parameters"' ../settings.json)
chmod +X chkrootkit
./chkrootkit $params >> ../results/chkrootkit.txt