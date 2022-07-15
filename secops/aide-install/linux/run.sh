cd "${0%/*}"

sudo apt-get install aide -y > /dev/null
apt-get install aide -y  > /dev/null
sudo apt-get aide jq -y  > /dev/null
apt-get aide jq -y  > /dev/null

# Example parameters
#portstoscan1=$(jq -r '."Ports to scan"' ../settings.json)
#subnet1=$(jq -r '."Network Subnet"' ../settings.json)
#maxratepps1=$(jq -r '."Network Subnet"' ../settings.json)

# write nscd cache stats to dns_cache
aide -i >> ../results/aide-init.txt
aide -u >> ../results/aide-update.txt

