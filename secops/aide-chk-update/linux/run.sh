cd "${0%/*}"

# Example parameters
#portstoscan1=$(jq -r '."Ports to scan"' ../settings.json)
#subnet1=$(jq -r '."Network Subnet"' ../settings.json)
#maxratepps1=$(jq -r '."Network Subnet"' ../settings.json)

# write nscd cache stats to dns_cache
aide aide -c /etc/aide/aide.conf -u >> ../results/aide-update.txt

