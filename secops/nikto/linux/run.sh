#!/bin/bash
cd "${0%/*}"



REQUIRED_PKGS="openssl"
PKGS_OK=$(dpkg-query -W --showformat='${Status}\n' $REQUIRED_PKGS|grep "install ok installed")
echo Checking for $REQUIRED_PKGS: $PKGS_OK
if [ "" = "$PKGS_OK" ]; then
  echo "No $REQUIRED_PKGS. Setting up $REQUIRED_PKGS."
  sudo apt-get --yes install $REQUIRED_PKGS 
  apt-get --yes install $REQUIRED_PKGS
fi

REQUIRED_PKGS1="libnet-ssleay-perl"
PKGS1_OK=$(dpkg-query -W --showformat='${Status}\n' $REQUIRED_PKGS1|grep "install ok installed")
echo Checking for $REQUIRED_PKGS1: $PKGS1_OK
if [ "" = "$PKGS1_OK" ]; then
  echo "No $REQUIRED_PKGS1. Setting up $REQUIRED_PKGS1."
  sudo apt-get --yes install $REQUIRED_PKGS1 
  apt-get --yes install $REQUIRED_PKGS1
fi

REQUIRED_PKGS2="libauthen-pam-perl"
PKGS2_OK=$(dpkg-query -W --showformat='${Status}\n' $REQUIRED_PKGS2|grep "install ok installed")
echo Checking for $REQUIRED_PKGS2: $PKGS2_OK
if [ "" = "$PKGS2_OK" ]; then
  echo "No $REQUIRED_PKGS2. Setting up $REQUIRED_PKGS2."
  sudo apt-get --yes install $REQUIRED_PKGS2 
  apt-get --yes install $REQUIRED_PKGS2
fi

REQUIRED_PKGS3="libio-pty-perl"
PKGS3_OK=$(dpkg-query -W --showformat='${Status}\n' $REQUIRED_PKGS3|grep "install ok installed")
echo Checking for $REQUIRED_PKGS3: $PKGS3_OK
if [ "" = "$PKGS3_OK" ]; then
  echo "No $REQUIRED_PKGS3. Setting up $REQUIRED_PKGS3."
  sudo apt-get --yes install $REQUIRED_PKGS3 
  apt-get --yes install $REQUIRED_PKGS3
fi

REQUIRED_PKGS4="jq"
PKGS4_OK=$(dpkg-query -W --showformat='${Status}\n' $REQUIRED_PKGS4|grep "install ok installed")
echo Checking for $REQUIRED_PKGS4: $PKGS4_OK
if [ "" = "$PKGS4_OK" ]; then
  echo "No $REQUIRED_PKGS4. Setting up $REQUIRED_PKGS4."
  sudo apt-get --yes install $REQUIRED_PKGS4 
  apt-get --yes install $REQUIRED_PKGS4
fi


chmod +x ./nikto.pl

hosttoscan1=$(jq -r '."hosttoscan1"' ../settings.json)
#subnet1=$(jq -r '."Network Subnet"' ../settings.json)
#maxratepps1=$(jq -r '."Network Subnet"' ../settings.json)

# write nscd cache stats to dns_cache

perl ./nikto.pl --host $hosttoscan1 >> ../results/nikto.txt

