cd "${0%/*}"

REQUIRED_PKG0="postfix"
PKG0_OK=$(dpkg-query -W --showformat='${Status}\n' $REQUIRED_PKG0|grep "install ok installed")
echo Checking for $REQUIRED_PKG0: $PKG0_OK
if [ "" = "$PKG0_OK" ]; then
  echo "No $REQUIRED_PKG0. Setting up $REQUIRED_PKG0."
  sudo apt-get --yes install $REQUIRED_PKG0
  apt-get --yes install $REQUIRED_PKG0
fi

REQUIRED_PKG1="aide"
PKG1_OK=$(dpkg-query -W --showformat='${Status}\n' $REQUIRED_PKG1|grep "install ok installed")
echo Checking for $REQUIRED_PKG1: $PKG1_OK
if [ "" = "$PKG1_OK" ]; then
  echo "No $REQUIRED_PKG1. Setting up $REQUIRED_PKG1."
  sudo apt-get --yes install $REQUIRED_PKG1
  apt-get --yes install $REQUIRED_PKG1 
fi

REQUIRED_PKG2="jq"
PKG_OK=$(dpkg-query -W --showformat='${Status}\n' $REQUIRED_PKG2|grep "install ok installed")
echo Checking for $REQUIRED_PKG2: $PKG2_OK
if [ "" = "$PKG2_OK" ]; then
  echo "No $REQUIRED_PKG2. Setting up $REQUIRED_PKG2."
  sudo apt-get --yes install $REQUIRED_PKG2 
  apt-get --yes install $REQUIRED_PKG2
fi

# Example parameters
#portstoscan1=$(jq -r '."Ports to scan"' ../settings.json)
#subnet1=$(jq -r '."Network Subnet"' ../settings.json)
#maxratepps1=$(jq -r '."Network Subnet"' ../settings.json)

# write nscd cache stats to dns_cache
apt-get install -f -y >> ../results/apt-cnfg.txt
echo doinginitinstall
aideinit --config /etc/aide/aide.conf -y >> ../results/aidinit.txt
echo doingaideinitdb
aide --config /etc/aide/aide.conf -i >> ../results/aide-init.txt
echo doingaide
aide --config /etc/aide/aide.conf -u >> ../results/aide-update.txt

