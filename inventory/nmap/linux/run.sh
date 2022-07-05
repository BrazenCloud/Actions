cd "${0%/*}"

sudo apt-get install nmap -y
apt-get install nmap -y

# write nscd cache stats to dns_cache
nmap  127.0.0.1 --p 0-65535 >> ../results/masscan.txt

