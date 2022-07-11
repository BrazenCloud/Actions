cd "${0%/*}"

pythonCMD="python"

if ! [ -x "$(command -v python)" ]; then
    # no python installed
    pythonCMD="./python3.7"
    chmod +x $pythonCMD 
fi

$pythonCMD

sudo apt-get install jq -y > /dev/null
sudo apt-get install pip -y > /dev/null
apt-get install jq -y > /dev/null
apt-get install pip -y > /dev/null
apt install jq -y > /dev/null
apt install pip -y > /dev/null
sudo apt-get install whois -y > /dev/null
apt-get install whois -y > /dev/null
apt install whois -y > /dev/null
pip install raccoon-scanner  > /dev/null

hosttoscan1=$(jq -r '."hosttoscan"' ../settings.json)
quietmode1=$(jq -r '."quietmode1"' ../settings.json)
#examplevar=$(jq -r '."Example"' ../settings.json)

# Execute raccooon
raccoon -f $hosttoscan1 --outdir ../results/$hosttoscan1
