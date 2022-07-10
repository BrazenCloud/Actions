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
pip install raccoon-scanner

hosttoscan1=$(jq -r '."hosttoscan"' ../settings.json)
verbose1=$(jq -r '."quietmode"' ../settings.json)
#examplevar=$(jq -r '."Example"' ../settings.json)

# Execute raccooon
raccoon -f $hosttoscan1 $verbose1 --vulners-nmap-scan -o ../results.txt

