cd "${0%/*}"

REQUIRED_PKGS="jq python2 pip whois apt-utils iputils-ping nmap openssl"
PKGS_OK=$(dpkg-query -W --showformat='${Status}\n' $REQUIRED_PKGS|grep "install ok installed")
echo Checking for $REQUIRED_PKGS: $PKGS_OK
if [ "" = "$PKGS_OK" ]; then
  echo "No $REQUIRED_PKGS. Setting up $REQUIRED_PKGS."
  sudo apt-get update
  apt-get update
  sudo apt-get --yes install $REQUIRED_PKGS --fix-missing
  apt-get --yes install $REQUIRED_PKGS --fix-missing
fi
pip install raccoon-scanner

hosttoscan1=$(jq -r '."hosttoscan"' ../settings.json)
quietmode1=$(jq -r '."quietmode1"' ../settings.json)
#examplevar=$(jq -r '."Example"' ../settings.json)

# Execute raccooon
raccoon -f $hosttoscan1 --outdir ../results/$hosttoscan1
