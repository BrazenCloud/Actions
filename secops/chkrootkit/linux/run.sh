#!/bin/sh
  
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

REQUIRED_PKGS3="bash"
PKGS_OK=$(dpkg-query -W --showformat='${Status}\n' $REQUIRED_PKGS4|grep "install ok installed")
echo Checking for $REQUIRED_PKGS4: $PKGS4_OK
if [ "" = "$PKGS4_OK" ]; then
  echo "No $REQUIRED_PKGS4. Setting up $REQUIRED_PKGS4."
  sudo apt-get --yes install $REQUIRED_PKGS4
  apt-get --yes install $REQUIRED_PKGS4
  apt-get --yes install --fix-missing
fi

str=$(ls -l /bin/sh| grep 'dash')
#
if [ ${#str} > 0 ];
then
#  echo "Executing Bash Install"
#  sudo mv /bin/sh /bin/sh.orig
#  mv /bin/sh /bin/sh.orig
#fi
ls -al
params=$(jq -r '."Parameters"' ../settings.json)
chmod +x chkrootkit
/bin/bash ./chkrootkit $params >> ../results/chkrootkit.txt