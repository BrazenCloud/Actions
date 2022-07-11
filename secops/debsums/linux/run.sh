cd "${0%/*}"

sudo apt-get install debsums -y > /dev/null
apt-get install debsums -y > /dev/null
sudo apt install debsums -y > /dev/null

sudo apt-get install jq -y > /dev/null
apt-get install jq -y > /dev/null

params=$(jq -r '."Parameters"' ../settings.json)

# outputting debsums to results
debsums $params >> ../results/debsums.txt

