cd "${0%/*}"

# examplevar1=$(jq -r '."Ports to scan"' ../settings.json)
# examplevar1=$(jq -r '."Network Subnet"' ../settings.json)

# Execute yum verify-all and save results
yum verify-all >> ../results/yum-verify.txt

