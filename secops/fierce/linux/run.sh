#!/bin/bash
cd "${0%/*}"

REQUIRED_PKGS1="jq"
PKGS1_OK=$(dpkg-query -W --showformat='${Status}\n' $REQUIRED_PKGS1|grep "install ok installed")
echo Checking for $REQUIRED_PKGS1: $PKGS1_OK
if [ "" = "$PKGS1_OK" ]; then
  echo "No $REQUIRED_PKGS1. Setting up $REQUIRED_PKGS1."
  sudo apt-get --yes install $REQUIRED_PKGS1 
  apt-get --yes install $REQUIRED_PKGS1
fi

REQUIRED_PKGS4="python3"
PKGS4_OK=$(dpkg-query -W --showformat='${Status}\n' $REQUIRED_PKGS4|grep "install ok installed")
echo Checking for $REQUIRED_PKGS4: $PKGS4_OK
if [ "" = "$PKGS4_OK" ]; then
  echo "No $REQUIRED_PKGS4. Setting up $REQUIRED_PKGS4."
  sudo apt-get --yes install $REQUIRED_PKGS4 
  apt-get --yes install $REQUIRED_PKGS4
fi

REQUIRED_PKGS2="pip3"
PKGS2_OK=$(dpkg-query -W --showformat='${Status}\n' $REQUIRED_PKGS2|grep "install ok installed")
echo Checking for $REQUIRED_PKG2S: $PKGS2_OK
if [ "" = "$PKGS2_OK" ]; then
  echo "No $REQUIRED_PKGS2. Setting up $REQUIRED_PKGS2."
  sudo apt-get --yes install $REQUIRED_PKGS2 
  apt-get --yes install $REQUIRED_PKGS2
fi

REQUIRED_PKGS3="whois"
PKGS3_OK=$(dpkg-query -W --showformat='${Status}\n' $REQUIRED_PKGS3|grep "install ok installed")
echo Checking for $REQUIRED_PKGS: $PKGS3_OK
if [ "" = "$PKGS3_OK" ]; then
  echo "No $REQUIRED_PKGS3. Setting up $REQUIRED_PKGS3."
  sudo apt-get --yes install $REQUIRED_PKGS3
  apt-get --yes install $REQUIRED_PKGS3
fi

pip3 install fierce  > /dev/null


hosttoscan=$(jq -r '."hosttoscan"' ../settings.json)
widemode=$(jq -r '."widemode"' ../settings.json)
#quietmode=$(jq -r '."quietmode"' ../settings.json)


# if [ $quietmode -eq 'true' ]
# then
# quietmode="-q"
# # do the thing
# else
# quietemode=""
# # do the thing
# fi

if [ "$widemode" == "true" ]
then
  widemode="--wide"
# do the thing
else
  widemode=""
# do the thing
fi

# Execute Fierce
fierce --domain $hosttoscan --connect $widemode >> ../results/$hosttoscan.txt
