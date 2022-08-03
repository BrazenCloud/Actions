#!/bin/sh

cd "${0%/*}"

REQUIRED_PKG1="net-tools"
PKG_OK1=$(dpkg-query -W --showformat='${Status}\n' $REQUIRED_PKG1|grep "install ok installed")
echo Checking for $REQUIRED_PKG1: $PKG1_OK
if [ "" = "$PKG1_OK" ]; then
  echo "No $REQUIRED_PKG1. Setting up $REQUIRED_PKG1."
  sudo apt-get --yes install $REQUIRED_PKG1
  apt-get --yes install $REQUIRED_PKG1 
fi

REQUIRED_PKG2="python2"
PKG_OK2=$(dpkg-query -W --showformat='${Status}\n' $REQUIRED_PKG2|grep "install ok installed")
echo Checking for $REQUIRED_PKG2: $PKG1_OK
if [ "" = "$PKG2_OK" ]; then
  echo "No $REQUIRED_PKG1. Setting up $REQUIRED_PKG2."
  sudo apt-get --yes install $REQUIRED_PKG2
  apt-get --yes install $REQUIRED_PKG2 
fi

python netstat.py >> ../results/results.json

