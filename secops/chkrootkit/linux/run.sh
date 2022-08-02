cd "${0%/*}"

REQUIRED_PKG2="jq apt-utils"
PKG_OK=$(dpkg-query -W --showformat='${Status}\n' $REQUIRED_PKG2|grep "install ok installed")
echo Checking for $REQUIRED_PKG2: $PKG2_OK
if [ "" = "$PKG2_OK" ]; then
  echo "No $REQUIRED_PKG2. Setting up $REQUIRED_PKG2."
  sudo apt-get --yes install $REQUIRED_PKG2 
  apt-get --yes install $REQUIRED_PKG2
fi


params=$(jq -r '."Parameters"' ../settings.json)
chmod +x ./chkrootkit
chkrootkit $params