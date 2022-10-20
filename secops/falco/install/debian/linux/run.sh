#!/bin/bash

# check for current package manager
declare -A osInfo;
osInfo[/etc/redhat-release]=yum
osInfo[/etc/arch-release]=pacman
osInfo[/etc/gentoo-release]=emerge
osInfo[/etc/SuSE-release]=zypp
osInfo[/etc/debian_version]=apt-get
osInfo[/etc/alpine-release]=apk

for f in ${!osInfo[@]}
do
    if [[ -f $f ]];then
        #echo Package manager: ${osInfo[$f]}
        pman=${osInfo[$f]}
    fi
done

# check if jq is installed
if ! [ -x "$(command -v jq)" ]; then
    echo "Installing jq"

    # check for sudo, install
    if [ -x "$(command -v sudo)" ]; then
        sudo $pman install jq -y
    else
        $pman install jq -y
    fi
else
    echo "jq already installed"
fi

installService=$(jq -r '."Install Service"' ./settings.json)
startService=$(jq -r '."Start Service"' ./settings.json)

# https://falco.org/docs/getting-started/installation/#debian
# Trust the falcosecurity GPG key, configure the apt repository, and update the package list:
curl -s https://falco.org/repo/falcosecurity-3672BA8F.asc | apt-key add -
echo "deb https://download.falco.org/packages/deb stable main" | tee -a /etc/apt/sources.list.d/falcosecurity.list
apt-get update -y

# Install kernel headers:
apt-get -y install linux-headers-$(uname -r)

# Install Falco:
apt-get install -y falco

if $installService == 'true'; then
    # install driver
    falco-driver-loader

    if $startService == 'true'; then
        # start service
        systemctl enable falco
        systemctl start falco
    fi
fi