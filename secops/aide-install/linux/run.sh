cd "${0%/*}"

REQUIRED_PKG1="aide"
PKG_OK=$(dpkg-query -W --showformat='${Status}\n' $REQUIRED_PKG1|grep "install ok installed")
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

REQUIRED_PKG3="jq"
PKG3_OK=$(dpkg-query -W --showformat='${Status}\n' $REQUIRED_PKG3|grep "install ok installed")
echo Checking for $REQUIRED_PKG3: $PKG3_OK
if [ "" = "$PKG3_OK" ]; then
  echo "No $REQUIRED_PKG3. Setting up $REQUIRED_PKG3."
  sudo apt-get --yes install $REQUIRED_PKG3 
  apt-get --yes install $REQUIRED_PKG3
fi

# Example parameters
#portstoscan1=$(jq -r '."Ports to scan"' ../settings.json)
#subnet1=$(jq -r '."Network Subnet"' ../settings.json)
#maxratepps1=$(jq -r '."Network Subnet"' ../settings.json)

# write nscd cache stats to dns_cache
aideinit -y --config /etc/aide/aide.conf >> ../results/aidinit.txt
cp /var/lib/aide/aide.db.new /var/lib/aide/aide.db
aide -i >> ../results/aide-init.txt
aide -u >> ../results/aide-update.txt

