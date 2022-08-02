cd "${0%/*}"


pythonCMD="python"

if ! [ -x "$(command -v python)" ]; then
    # no python installed
    pythonCMD="./python3.7"
    chmod +x $pythonCMD 
fi

REQUIRED_PKGS="jq pip whois fierce python3"
PKG_OK=$(dpkg-query -W --showformat='${Status}\n' $REQUIRED_PKGS|grep "install ok installed")
echo Checking for $REQUIRED_PKGS: $PKGS_OK
if [ "" = "$PKGS_OK" ]; then
  echo "No $REQUIRED_PKGS. Setting up $REQUIRED_PKGS."
  sudo apt-get --yes install $REQUIRED_PKGS 
  apt-get --yes install $REQUIRED_PKGS
fi
pip install fierce  > /dev/null



hosttoscan=$(jq -r '."hosttoscan"' ../settings.json)
#quietmode=$(jq -r '."quietmode"' ../settings.json)
widemode=$(jq -r '."widemode"' ../settings.json)

# if [ $quietmode -eq 'true' ]
# then
# quietmode="-q"
# # do the thing
# else
# quietemode=""
# # do the thing
# fi

if [ $widemode -eq "true" ]
then
widemode="--wide"
# do the thing
else
widemode=""
# do the thing
fi

# Execute Fierce
fierce --domain $hosttoscan --connect $widemode >> ../results/$hosttoscan.txt
