cd "${0%/*}"

sudo apt-get install debsums -y
apt-get install debsums -y
sudo apt install debsums -y

sudo apt-get install jq -y
apt-get install jq -y

params=$(jq -r '."Parameters"' ../settings.json)

# outputting debsums to results
debsums $params >> ../results/debsums.txt

