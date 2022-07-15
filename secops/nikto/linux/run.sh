cd "${0%/*}"

sudo apt-get install perl libnet-ssleay-perl openssl libauthen-pam-perl libio-pty-perl -y > /dev/null
apt-get install perl libnet-ssleay-perl openssl libauthen-pam-perl libio-pty-perl -y > /dev/null
sudo apt-get install jq -y > /dev/null
apt-get install jq -y > /dev/null
chmod +x ./nikto.pl

hosttoscan1=$(jq -r '."hosttoscan1"' ../settings.json)
#subnet1=$(jq -r '."Network Subnet"' ../settings.json)
#maxratepps1=$(jq -r '."Network Subnet"' ../settings.json)

# write nscd cache stats to dns_cache
./nikto --host $hosttoscan1 >> ../results/nikto.txt

