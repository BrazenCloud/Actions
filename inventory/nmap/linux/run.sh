cd "${0%/*}"

REQUIRED_PKG1="nmap"
PKG_OK1=$(dpkg-query -W --showformat='${Status}\n' $REQUIRED_PKG1|grep "install ok installed")
echo Checking for $REQUIRED_PKG1: $PKG1_OK
if [ "" = "$PKG1_OK" ]; then
  echo "No $REQUIRED_PKG1. Setting up $REQUIRED_PKG1."
  sudo apt-get --yes install $REQUIRED_PKG1
  apt-get --yes install $REQUIRED_PKG1 
fi

REQUIRED_PKG2="jq"
PKG2_OK=$(dpkg-query -W --showformat='${Status}\n' $REQUIRED_PKG2|grep "install ok installed")
echo Checking for $REQUIRED_PKG2: $PKG2_OK
if [ "" = "$PKG2_OK" ]; then
  echo "No $REQUIRED_PKG2. Setting up $REQUIRED_PKG2."
  sudo apt-get --yes install $REQUIRED_PKG2 
  apt-get --yes install $REQUIRED_PKG2
fi

portstoscan1=$(jq -r '."Ports to scan"' ../settings.json)
subnet1=$(jq -r '."Network Subnet"' ../settings.json)
maxratepps1=$(jq -r '."Max rate packets per second"' ../settings.json)

# write nscd cache stats to dns_cache
nmap $subnet1 $portstoscan1 $maxratepps1 >> ../results/nmapscan.txt

