cd "${0%/*}"


#subnet1=$(jq -r '."Network Subnet"' ../settings.json)
#maxratepps1=$(jq -r '."Network Subnet"' ../settings.json)
chmod +x ioc-scanner
echo $Hash >> hashfile.txt

# write nscd cache stats to dns_cache
ioc-scanner -f ./hashfile.txt >> ../results/ioc-scanner.txt

