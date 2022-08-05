cd "${0%/*}"
IRED_PKGS="perl libnet-ssleay-perl openssl libauthen-pam-perl libio-pty-perl jq"
PKG_OK=$(dpkg-query -W --showformat='${Status}\n' $REQUIRED_PKG2|grep "install ok installed")
echo Checking for $REQUIRED_PKGS: $PKGS_OK
if [ "" = "$PKG2_OK" ]; then
  echo "No $REQUIRED_PKGS. Setting up $REQUIRED_PKGS."
  sudo apt-get --yes install $REQUIRED_PKGS 
  apt-get --yes install $REQUIRED_PKGS
fi

# check if jq is installed
if ! [ -x "$(command -v jq)" ]; then
    echo "Installing jq"

    # check for sudo, install
    if [ -x "$(command -v sudo)" ]; then
        sudo apt-get install jq -y
    else
        apt-get install jq -y
    fi
else
    echo "jq already installed"
fi

chmod +x ./nikto.pl

hosttoscan1=$(jq -r '."hosttoscan1"' ../settings.json)
#subnet1=$(jq -r '."Network Subnet"' ../settings.json)
#maxratepps1=$(jq -r '."Network Subnet"' ../settings.json)

# write nscd cache stats to dns_cache
./nikto --host $hosttoscan1 >> ../results/nikto.txt

