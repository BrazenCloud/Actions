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
pip install raccoon-scanner -y

hosttoscan1=$(jq -r '."hosttoscan"' ../settings.json)
verbose1=$(jq -r '."quietmode"' ../settings.json)
#examplevar=$(jq -r '."Example"' ../settings.json)

# Execute raccooon
raccoon $verbose1 -f --vulners-nmap-scan $hosttoscan1 -o ../results.txt

