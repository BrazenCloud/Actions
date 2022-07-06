cd "${0%/*}"

sudo apt-get install debsums -y
apt-get install debsums -y
sudo apt install debsums -y

# examplevar1=$(jq -r '."Ports to scan"' ../settings.json)
# examplevar1=$(jq -r '."Network Subnet"' ../settings.json)

# write nscd cache stats to dns_cache
debsums >> ../results/debsums.txt

