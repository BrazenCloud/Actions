cd "${0%/*}"

sudo apt-get install nmap -y
apt-get install nmap -y
sudo apt-get install jq -y
apt-get install jq -y

portstoscan1=$(jq -r '."Ports to scan"' ../settings.json)
subnet1=$(jq -r '."Network Subnet"' ../settings.json)
maxratepps1=$(jq -r '."Max rate packets per second"' ../settings.json)

# write nscd cache stats to dns_cache
nmap $subnet1 $portstoscan1 $maxratepps1 >> ../results/nmapscan.txt

