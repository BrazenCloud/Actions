#!/bin/bash
cd "${0%/*}"
REQIRED_PKGS="perl libnet-ssleay-perl openssl libauthen-pam-perl libio-pty-perl jq"
PKGS_OK=$(dpkg-query -W --showformat='${Status}\n' $REQUIRED_PKGS|grep "install ok installed")
echo Checking for $REQUIRED_PKGS: $PKGS_OK
if [ "" = "$PKGS_OK" ]; then
  echo "No $REQUIRED_PKGS. Setting up $REQUIRED_PKGS."
  sudo apt-get --yes install $REQUIRED_PKGS 
  apt-get --yes install $REQUIRED_PKGS
fi

chmod +x ./nikto.pl

hosttoscan1=$(jq -r '."hosttoscan1"' ../settings.json)
#subnet1=$(jq -r '."Network Subnet"' ../settings.json)
#maxratepps1=$(jq -r '."Network Subnet"' ../settings.json)

# write nscd cache stats to dns_cache
perl ./nikto.pl --host $hosttoscan1 >> ../results/nikto.txt

