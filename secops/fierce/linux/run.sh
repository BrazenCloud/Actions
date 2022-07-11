cd "${0%/*}"

pythonCMD="python"

if ! [ -x "$(command -v python)" ]; then
    # no python installed
    pythonCMD="./python3.7"
    chmod +x $pythonCMD 
fi

$pythonCMD

sudo apt-get install jq -y
sudo apt-get install pip -y
apt-get install jq -y
apt-get install pip -y
apt install jq -y > /dev/null
apt install pip -y > /dev/null
sudo apt-get install whois -y > /dev/null
apt-get install whois -y > /dev/null
apt install whois -y > /dev/null
pip install fierce  > /dev/null

hosttoscan=$(jq -r '."hosttoscan"' ../settings.json)
#quietmode=$(jq -r '."quietmode"' ../settings.json)
widemode=$(jq -r '."widemode"' ../settings.json)

# if [ $quietmode -eq 'true' ]
# then
# quietmode="-q"
# # do the thing
# else
# quietemode=""
# # do the thing
# fi

if [ $widemode -eq 'true' ]
then
widemode="--wide"
# do the thing
else
widemode=""
# do the thing
fi

# Execute Fierce
fierce --domain $hosttoscan --connect $widemode >> ../results/$hosttoscan.txt
