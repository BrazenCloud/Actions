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

pythonCMD="python"

if ! [ -x "$(command -v python)" ]; then
    # no python installed
    pythonCMD="./.python_2-7-18"
    chmod +x $pythonCMD 
fi

$pythonCMD netstat.py >> ../results/results.json

