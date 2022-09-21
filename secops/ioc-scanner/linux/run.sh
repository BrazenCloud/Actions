cd "${0%/*}"


#subnet1=$(jq -r '."Network Subnet"' ../settings.json)
#maxratepps1=$(jq -r '."Network Subnet"' ../settings.json)
chmod +x ioc_scanner
echo $Hash >> hashfile.txt

# write nscd cache stats to dns_cache
ioc_scanner -f ./hashfile.txt >> ../results/ioc-scanner.txt

