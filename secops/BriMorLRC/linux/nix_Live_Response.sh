#!/bin/bash

# Last updated 05 September 2019 by Brian Moran (brian@brimorlabs.com)
# Please read "ReadMe.txt" for more information regarding GPL, the script itself, and changes
# RELEASE DATE: 20190905
# AUTHOR: Brian Moran (brian@brimorlabs.com)
# TWITTER: BriMor Labs (@BriMorLabs)
# Version: Live Response Collection (Cedarpelta Build - 20190905)
# Copyright: 2013-2019, Brian Moran


# This file is part of the Live Response Collection
# The Live Response Collection is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
# This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.
# You should have received a copy of the GNU General Public License along with this program.  If not, see <http://www.gnu.org/licenses/>.
# Additionally, usages of all tools fall under the express license agreement stated by the tool itself.

#INITIAL HOUSEKEEPING 
ScriptStart=$(date +%s)
lrcbuildname="Live Response Collection (Cedarpelta Build - 20190905)"
scriptname=`basename "$0"`
directorywherescriptrunsfrom=$(pwd) #Getting directory from where the script is running
modulepath="$directorywherescriptrunsfrom/Modules/"
runningfromexternal="no"
cname=$(hostname -s)
ts=$(date +%Y%m%d_%H%M%S)
computername=$cname\_$ts
mkdir -p $computername
printf "***** All commands run and (if applicable) any error messages *****\n" >> "$computername/$computername""_Processing_Details.txt"
printf "OS Type: nix\n" >> "$computername/$computername""_Processing_Details.txt"
printf "Computername: $cname\n" >> "$computername/$computername""_Processing_Details.txt"
printf "Time stamp: $ts\n" >> "$computername/$computername""_Processing_Details.txt"
printf "Live Response Collection version: $lrcbuildname\n" >> "$computername/$computername""_Processing_Details.txt"
printf "Live Response Collection script run: $scriptname\n\n" >> "$computername/$computername""_Processing_Details.txt"
printf "mkdir -p $computername\n" >> "$computername/$computername""_Processing_Details.txt"


#DIRECTORY CREATION MODULE
#Running directory creation module
echo ""
echo "***** Beginning nix Directory Creation module *****"
source "$directorywherescriptrunsfrom/Modules/nix-DirectoryCreation.sh"
echo "***** Ending nix Directory Creation module *****"
echo ""

#HIDDEN FILES
find / -name ".*" -ls >> $computername/LiveResponseData/BasicInfo/HiddenFiles.txt
echo "find / -name \".*\" -ls"

#LOGS
cp /var/log/*.log* $computername/LiveResponseData/Logs/var
cp -r /etc/cron* $computername/LiveResponseData/Logs/cron

#BASIC INFORMATION

date >> $computername/LiveResponseData/BasicInfo/date.txt
echo "date"
hostname >> $computername/LiveResponseData/BasicInfo/hostname.txt
echo "hostname"
who >> $computername/LiveResponseData/BasicInfo/Logged_In_Users.txt
echo "who"
ps aux --forest >> $computername/LiveResponseData/BasicInfo/List_of_Running_Processes.txt
echo "ps aux --forest"
pstree -ah >> $computername/LiveResponseData/BasicInfo/Process_tree_and_arguments.txt
echo "pstree -ah"
mount >> $computername/LiveResponseData/BasicInfo/Mounted_items.txt
echo "mount"
diskutil list >> $computername/LiveResponseData/BasicInfo/Disk_utility.txt
echo "diskutil"
kextstat -l >> $computername/LiveResponseData/BasicInfo/Loaded_Kernel_Extensions.txt
echo "kextstat -l"
uptime >> $computername/LiveResponseData/BasicInfo/System_uptime.txt
echo "uptime"
uname -a >> $computername/LiveResponseData/BasicInfo/System_environment.txt
echo "uname -a"
printenv >> $computername/LiveResponseData/BasicInfo/System_environment_detailed.txt
echo "prinenv"
cat /proc/version >> $computername/LiveResponseData/BasicInfo/OS_kernel_version.txt
echo "cat /proc/version"
top -n 1 -b >> $computername/LiveResponseData/BasicInfo/Process_memory_usage.txt
echo "top -n 1 -b"


#This needs to be flavor specific
service --status-all | grep + >> $computername/LiveResponseData/BasicInfo/Running_services.txt
echo "service --status-all | grep +"
lsmod | head >> $computername/LiveResponseData/BasicInfo/Loaded_modules.txt
echo "lsmod | head"
last >> $computername/LiveResponseData/BasicInfo/Last_logins.txt
echo "last"

#USER INFORMATION

cat /etc/passwd >> $computername/LiveResponseData/UserInfo/passwd.txt
echo "cat /etc/passwd"
cat /etc/group >> $computername/LiveResponseData/UserInfo/group.txt
echo "cat /etc/group"
lastlog >> $computername/LiveResponseData/UserInfo/Last_login_per_user.txt
echo "lastlog"
whoami >> $computername/LiveResponseData/BasicInfo/whoami.txt
echo "whoami"
logname >> $computername/LiveResponseData/BasicInfo/logname.txt
echo "logname"
id >> $computername/LiveResponseData/BasicInfo/id.txt
echo "id"
for i in `ls /home/`
do 
	cat /home/$i/.bash_history >> $computername/LiveResponseData/UserInfo/home-$i-bash_History.txt
	echo "cat $i bash_history"
done

#PERSISTENCE MECHANISMS

# TO BE FILLED IN


#NETWORK INFO

netstat -anp >> $computername/LiveResponseData/NetworkInfo/netstat_current_connections.txt
echo "netstat"
ip link | grep PROMISC >> $computername/LiveResponseData/NetworkInfo/PROMISC_adapter_check.txt
echo "PROMISC adapters"
ss >> $computername/LiveResponseData/NetworkInfo/socket_statistics.txt
echo "ss"
lsof -i -n -P>> $computername/LiveResponseData/NetworkInfo/lsof_network_connections.txt
echo "lsof -i -n -P"
netstat -rn >> $computername/LiveResponseData/NetworkInfo/Routing_table.txt
echo "netstat -rn"
arp -an >> $computername/LiveResponseData/NetworkInfo/ARP_table.txt
echo "arp -an"
ifconfig -a >> $computername/LiveResponseData/NetworkInfo/Network_interface_info.txt
echo "ifconfig -a"
cat /etc/hosts.allow >> $computername/LiveResponseData/NetworkInfo/Hosts_allow.txt
echo "cat /etc/hosts.allow"
cat /etc/hosts.deny >> $computername/LiveResponseData/NetworkInfo/Hosts_deny.txt
echo "cat /etc/hosts.deny"


#PROCESSING DETAILS AND HASHES
echo OS Type: nix >> $computername/Processing_Details_and_Hashes.txt
echo Computername: $cname >> $computername/Processing_Details_and_Hashes.txt
echo Time stamp: $ts >> $computername/Processing_Details_and_Hashes.txt
echo >> $computername/Processing_Details_and_Hashes.txt
echo ==========MD5 HASHES========== >> $computername/Processing_Details_and_Hashes.txt
find $computername -type f \( ! -name Processing_Details_and_Hashes.txt \) -exec md5sum {} \; >> $computername/Processing_Details_and_Hashes.txt
echo >> $computername/Processing_Details_and_Hashes.txt
echo ==========SHA256 HASHES========== >> $computername/Processing_Details_and_Hashes.txt
find $computername -type f \( ! -name Processing_Details_and_Hashes.txt \) -exec shasum -a 256 {} \; >> $computername/Processing_Details_and_Hashes.txt
echo "Computing hashes of files"



#LIST_OF_ALL_UPDATES
#Version 1.1 - Changed typo preventing post processing file hashing to occur. Fixed typo adding "v" to filename
#Version 1.0 - Initial compilation and release of nix data gathering
exit
