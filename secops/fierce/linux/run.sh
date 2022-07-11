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
apt install jq -y
apt install pip -y
sudo apt-get install whois -y
apt-get install whois -y
apt install whois -y
pip install fierce

hosttoscan1=$(jq -r '."hosttoscan"' ../settings.json)
quietmode1=$(jq -r '."quietmode1"' ../settings.json)
#examplevar=$(jq -r '."Example"' ../settings.json)

# Execute Fierce
fierce --domain $hosttoscan1 --connect >> ../results/$hosttoscan1.txt
