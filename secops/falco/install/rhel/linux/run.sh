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

# Trust the falcosecurity GPG key and configure the yum repository:
rpm --import https://falco.org/repo/falcosecurity-3672BA8F.asc
curl -s -o /etc/yum.repos.d/falcosecurity.repo https://falco.org/repo/falcosecurity-rpm.repo

# Note — The following command is required only if DKMS and make are not available in the distribution. You can verify if DKMS is available using yum list make dkms. If necessary install it using: yum install epel-release (or amazon-linux-extras install epel in case of amzn2), then yum install make dkms.

# Install kernel headers:
yum -y install kernel-devel-$(uname -r)

# Note — If the package was not found by the above command, you might need to run yum distro-sync in order to fix it. Rebooting the system may be required.

# Install Falco:
yum -y install falco

if $installService == 'true'; then
    # install driver
    falco-driver-loader

    if $startService == 'true'; then
        # start service
        systemctl enable falco
        systemctl start falco
    fi
fi