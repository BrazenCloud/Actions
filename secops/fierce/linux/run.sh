cd "${0%/*}"

REQUIRED_PKGS="jq pip whois fierce python3"
PKG_OKS=$(dpkg-query -W --showformat='${Status}\n' $REQUIRED_PKGS|grep "install ok installed")
echo Checking for $REQUIRED_PKGS: $PKGS_OK
if [ "" = "$PKGS_OK" ]; then
  echo "No $REQUIRED_PKGS. Setting up $REQUIRED_PKGS."
  sudo apt-get --yes install $REQUIRED_PKGS 
  apt-get --yes install $REQUIRED_PKGS
fi
pip install fierce  > /dev/null



hosttoscan=$(jq -r '."hosttoscan"' ../settings.json)
widemode=$(jq -r '."widemode"' ../settings.json)
#quietmode=$(jq -r '."quietmode"' ../settings.json)


# if [ $quietmode -eq 'true' ]
# then
# quietmode="-q"
# # do the thing
# else
# quietemode=""
# # do the thing
# fi

if [ $widemode == 'true' ]
then
  echo true
# do the thing
else
  echo false
# do the thing
fi

# Execute Fierce
fierce --domain $hosttoscan --connect $widemode >> ../results/$hosttoscan.txt
