cd "${0%/*}"

sudo apt-get install jq -y
sudo apt-get install pip -y
sudo apt install python3 -y
sudo apt install seclists -y
sudo apt install curl -y
sudo apt install enum4linux -y
sudo apt install gobuster -y
sudo apt install hydra -y
sudo apt install ldap-utils -y
sudo apt install medusa -y
sudo apt install nbtscan -y
sudo apt install nikto -y
sudo apt install nmap -y
sudo apt install onesixtyone -y
sudo apt install oscanner -y
sudo apt install pandoc -y
sudo apt install patator -y
sudo apt install nfs-common -y
sudo apt install smbclient -y
sudo apt install smbmap -y
sudo apt install smtp-user-enum -y
sudo apt install snmp -y
sudo apt install sslscan -y
sudo apt install sipvicious -y
sudo apt install tnscmd10g -y
sudo apt install whatweb -y
sudo apt install wkhtmltopdf -y
sudo apt install wpscan -y

apt-get install jq -y
apt-get install pip -y
apt install python3 -y
apt install seclists -y
apt install curl -y
apt install enum4linux -y
apt install gobuster -y
apt install hydra -y
apt install ldap-utils -y
apt install medusa -y
apt install nbtscan -y
apt install nikto -y
apt install nmap -y
apt install onesixtyone -y
apt install oscanner -y
apt install pandoc -y
apt install patator -y
apt install nfs-common -y
apt install smbclient -y
apt install smbmap -y
apt install smtp-user-enum -y
apt install snmp -y
apt install sslscan -y
apt install sipvicious -y
apt install tnscmd10g -y
apt install whatweb -y
apt install wkhtmltopdf -y
apt install wpscan -y
pip install -r requirements.txt

hosttoscan1=$(jq -r '."hosttoscan"' ../settings.json)
verbose1=$(jq -r '."verbose"' ../settings.json)
#examplevar=$(jq -r '."Example"' ../settings.json)

# Execute intelspy
python3 intelspy.py -h $hosttoscan1 $verbose1 >> ../results/intelspy.txt

