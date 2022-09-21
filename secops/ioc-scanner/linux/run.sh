cd "${0%/*}"

REQIRED_PKGS="jq"
PKGS_OK=$(dpkg-query -W --showformat='${Status}\n' $REQUIRED_PKGS|grep "install ok installed")
echo Checking for $REQUIRED_PKGS: $PKGS_OK
if [ "" = "$PKGS_OK" ]; then
  echo "No $REQUIRED_PKGS. Setting up $REQUIRED_PKGS."
  sudo apt-get --yes install $REQUIRED_PKGS 
  apt-get --yes install $REQUIRED_PKGS
fi

Hash=$(jq -r '."Hash"' ../settings.json)
#subnet1=$(jq -r '."Network Subnet"' ../settings.json)
#maxratepps1=$(jq -r '."Network Subnet"' ../settings.json)
chmod +x ./ioc_scanner
rm hashfile.txt
echo $Hash >> hashfile.txt

# write nscd cache stats to dns_cache
./ioc_scanner -f ./hashfile.txt >> ../results/ioc-scanner.txt

