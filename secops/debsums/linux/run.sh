cd "${0%/*}"

REQUIRED_PKG2="debsums"
PKG_OK=$(dpkg-query -W --showformat='${Status}\n' $REQUIRED_PKG2|grep "install ok installed")
echo Checking for $REQUIRED_PKG2: $PKG2_OK
if [ "" = "$PKG2_OK" ]; then
  echo "No $REQUIRED_PKG2. Setting up $REQUIRED_PKG2."
  sudo apt-get --yes install $REQUIRED_PKG2 
  apt-get --yes install $REQUIRED_PKG2
fi

REQUIRED_PKG2="jq"
PKG_OK=$(dpkg-query -W --showformat='${Status}\n' $REQUIRED_PKG2|grep "install ok installed")
echo Checking for $REQUIRED_PKG2: $PKG2_OK
if [ "" = "$PKG2_OK" ]; then
  echo "No $REQUIRED_PKG2. Setting up $REQUIRED_PKG2."
  sudo apt-get --yes install $REQUIRED_PKG2 
  apt-get --yes install $REQUIRED_PKG2
fi

silence=$(jq -r '."Silence Good Package Output"' ../settings.json)

if [ $silence = true ]
then
# Execute Debsums
debsums -s >> ../results/debsums.txt
else
# Execute Debsums
# outputting debsums to results
debsums >> ../results/debsums.txt
fi
echo "Action Done"




