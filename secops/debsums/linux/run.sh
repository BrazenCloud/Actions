cd "${0%/*}"

sudo apt-get install debsums -y > /dev/null
apt-get install debsums -y > /dev/null
sudo apt install debsums -y > /dev/null

sudo apt-get install jq -y > /dev/null
apt-get install jq -y > /dev/null

silence=$(jq -r '."Silence Good Package Output"' ../settings.json)

if [ $silence = true ]
then
# Execute Debsums
debsums -s >> ../results/debsums.txt
else
# Execute Debsums
# outputting debsums to results
debsums >> ../results/debsums.txt
fi
echo "Action Done"




