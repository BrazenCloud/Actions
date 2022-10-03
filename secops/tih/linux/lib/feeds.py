__author__ = '@abhinavbom a.k.a Darkl0rd'

###List of known IPs from various sources###

#Emerging Threats Community

emerging_threat_compromisedIP = "http://rules.emergingthreats.net/blockrules/compromised-ips.txt"
emerging_threat_blockedIP = "http://rules.emergingthreats.net/fwrules/emerging-Block-IPs.txt"
emerging_threat_russian_IP = "http://doc.emergingthreats.net/pub/Main/RussianBusinessNetwork/RussianBusinessNetworkIPs.txt"
emerging_threat_malvertisers = "http://doc.emergingthreats.net/pub/Main/RussianBusinessNetwork/emerging-rbn-malvertisers.txt"


#Project Honeynet
honeypot_ip = "http://www.projecthoneypot.org/list_of_ips.php?rss=1"

#SANS Institute
sans_ip = "https://isc.sans.edu/ipsascii.html?limit=2000"

#Blocklist.de
block_list = "http://www.blocklist.de/lists/all.txt"

#AlienVault IP Reputation
alien = "https://reputation.alienvault.com/reputation.generic"

#Abuse.ch zeus tracker
zeus_tracker = "https://zeustracker.abuse.ch/blocklist.php?download=ipblocklist"

#Malc0de Blacklist IPs
malcode_ip = "http://malc0de.com/bl/IP_Blacklist.txt"

#Malware Domain List (MDL) Malware C&C IPs
mdl_ip = "http://www.malwaredomainlist.com/hostslist/ip.txt"

#TALOS IP Blacklist
talos_ip = "http://talosintel.com/files/additional_resources/ips_blacklist/ip-filter.blf"

#CI Army Bad IPs
ci_army_ip = "http://www.ciarmy.com/list/ci-badguys.txt"

#NoThink.org Honeypot Project By Matteo Cantoni
nothink_dns = "http://www.nothink.org/blacklist/blacklist_malware_dns.txt"
nothink_http = "http://www.nothink.org/blacklist/blacklist_malware_http.txt"
nothink_irc = "http://www.nothink.org/blacklist/blacklist_malware_irc.txt"
nothink_ssh = "http://www.nothink.org/blacklist/blacklist_ssh_all.txt"

#TOR exit nodes
tor_exit_nodes = "https://check.torproject.org/exit-addresses"

#korean & Chinese Spam IP feed

korean_ip = "http://www.okean.com/korea.txt"

#Bad IPs listr for last 1000 hours
bad_ip = "http://www.badips.com/get/list/apache-wordpress/0?age=1000h"

###List of Domains goes here ###

#Open-phish
open_pish =  "https://openphish.com/feed.txt"

#Joewein Blacklist
joewein_domains = 'http://www.joewein.net/dl/bl/dom-bl.txt'

###Ocasionally updated feeds for Email blacklisting###
#Joewein Blacklist
joewein_email = 'http://www.joewein.net/dl/bl/from-bl.txt'

OSINT_IP = {
    "Emerging Threat Compromised IP Feed": emerging_threat_compromisedIP,
    "Emerging Threat Blocked IP feed": emerging_threat_blockedIP,
    "Emerging Threat Russian Business Network IP feed": emerging_threat_russian_IP,
    "Emerging threat Malvertisement Network": emerging_threat_malvertisers,
    "Project HoneyNet IP feed": honeypot_ip,
    "SANS IP feed": sans_ip,
    "BlockList.de IP feed": block_list,
    "AlienVault IP reputation feed": alien,
    "Abuse.ch Zeus Tracker IP feed": zeus_tracker,
    "Malc0de Blacklist IP feed": malcode_ip,
    "Malware Domain List C&C IPs": mdl_ip,
    "Talos Blacklist IP feed": talos_ip,
    "CI Army IP feed": ci_army_ip,
    "Nothink.org Honeypot DNS IPs": nothink_dns,
    "Nothink.org Http CC IPs": nothink_http,
    "Nothink.org IRC bot IPs": nothink_irc,
    "Nothink.org SSH bruteforce IPs": nothink_ssh,
    "TOR Exit node IP": tor_exit_nodes,
    "Korean & Chinese Spam IP feed": korean_ip,
    "Bad-IPs DB for last 1000 hours": bad_ip
}

OSINT_URL = {
    "Open Phish DB for Phishing Websites": open_pish,
    "Joe Wein domain blacklist": joewein_domains

}

OSINT_EMAIL = {
    "Joe Wein Email blacklist": joewein_email
}
