#set directory to BrazenCloud agent directory
cd "${0%/*}"

# install required packages
REQUIRED_PKGS1="curl"
PKG1_OK=$(dpkg-query -W --showformat='${Status}\n' $REQUIRED_PKGS1|grep "install ok installed")
echo Checking for $REQUIRED_PKGS1: $PKG1_OK
if [ "" = "$PKG1_OK" ]; then
  echo "No $REQUIRED_PKGS1. Setting up $REQUIRED_PKGS1."
  sudo apt-get --yes install $REQUIRED_PKGS1 
  apt-get --yes install $REQUIRED_PKGS1
fi

REQUIRED_PKGS2="jq"
PKG2_OK=$(dpkg-query -W --showformat='${Status}\n' $REQUIRED_PKGS2|grep "install ok installed")
echo Checking for $REQUIRED_PKGS2: $PKG2_OK
if [ "" = "$PKG2_OK" ]; then
  echo "No $REQUIRED_PKGS2. Setting up $REQUIRED_PKGS2."
  sudo apt-get --yes install $REQUIRED_PKGS2
  apt-get --yes install $REQUIRED_PKGS2
fi

REQUIRED_PKGS3="sudo"
PKG3_OK=$(dpkg-query -W --showformat='${Status}\n' $REQUIRED_PKGS3|grep "install ok installed")
echo Checking for $REQUIRED_PKGS3: $PKG3_OK
if [ "" = "$PKG3_OK" ]; then
  echo "No $REQUIRED_PKGS3. Setting up $REQUIRED_PKGS3."
  sudo apt-get --yes install $REQUIRED_PKGS3
  apt-get --yes install $REQUIRED_PKGS3
fi

# call single file install command for fluentbit
curl https://raw.githubusercontent.com/fluent/fluent-bit/master/install.sh | sh

# Copy defaults without specific params to fluent-bit.conf file
cp ./fluent-bit.conf /etc/fluent-bit/fluent-bit.conf

#example setup parameters for cli
#hosttoscan1=$(jq -r '."hosttoscan1"' ../settings.json)
#subnet1=$(jq -r '."Network Subnet"' ../settings.json)
#maxratepps1=$(jq -r '."Network Subnet"' ../settings.json)

# execute cli command
service fluent-bit restart >> ../results/fluentbit.txt