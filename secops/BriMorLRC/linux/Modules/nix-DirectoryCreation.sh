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

modulesource=${BASH_SOURCE[0]}
modulename=${modulesource/$modulepath/}


echo ""
echo "***** Now running $modulename module *****"

printf "Comamnd Run: mkdir -p $computername/ForensicImages/Memory\n"
printf "Comamnd Run: mkdir -p $computername/ForensicImages/Memory\n" >> "$computername/$computername""_Processing_Details.txt"
mkdir -p $computername/ForensicImages/Memory >> "$computername/$computername""_Processing_Details.txt" 2>&1
printf "\n\n" >> "$computername/$computername""_Processing_Details.txt"

printf "Command Run: mkdir -p $computername/ForensicImages/DiskImage\n"
printf "Command Run: mkdir -p $computername/ForensicImages/DiskImage\n" >> "$computername/$computername""_Processing_Details.txt"
mkdir -p $computername/ForensicImages/DiskImage >> "$computername/$computername""_Processing_Details.txt" 2>&1
printf "\n\n" >> "$computername/$computername""_Processing_Details.txt"

printf "Command Run: mkdir -p $computername/LiveResponseData/BasicInfo\n"
printf "Command Run: mkdir -p $computername/LiveResponseData/BasicInfo\n" >> "$computername/$computername""_Processing_Details.txt"
mkdir -p $computername/LiveResponseData/BasicInfo >> "$computername/$computername""_Processing_Details.txt" 2>&1
printf "\n\n" >> "$computername/$computername""_Processing_Details.txt"

printf "Command Run: mkdir -p $computername/LiveResponseData/UserInfo\n"
printf "Command Run: mkdir -p $computername/LiveResponseData/UserInfo\n" >> "$computername/$computername""_Processing_Details.txt"
mkdir -p $computername/LiveResponseData/UserInfo >> "$computername/$computername""_Processing_Details.txt" 2>&1
printf "\n\n" >> "$computername/$computername""_Processing_Details.txt"

printf "Command Run: mkdir -p $computername/LiveResponseData/NetworkInfo\n"
printf "Command Run: mkdir -p $computername/LiveResponseData/NetworkInfo\n" >> "$computername/$computername""_Processing_Details.txt"
mkdir -p $computername/LiveResponseData/NetworkInfo >> "$computername/$computername""_Processing_Details.txt" 2>&1
printf "\n\n" >> "$computername/$computername""_Processing_Details.txt"

printf "Command Run: mkdir -p $computername/LiveResponseData/PersistenceMechanisms\n"
printf "Command Run: mkdir -p $computername/LiveResponseData/PersistenceMechanisms\n" >> "$computername/$computername""_Processing_Details.txt"
mkdir -p $computername/LiveResponseData/PersistenceMechanisms >> "$computername/$computername""_Processing_Details.txt" 2>&1
printf "\n\n" >> "$computername/$computername""_Processing_Details.txt"

printf "Command Run: mkdir -p $computername/LiveResponseData/Logs\n"
printf "Command Run: mkdir -p $computername/LiveResponseData/Logs\n" >> "$computername/$computername""_Processing_Details.txt"
mkdir -p $computername/LiveResponseData/Logs >> "$computername/$computername""_Processing_Details.txt" 2>&1
printf "\n\n" >> "$computername/$computername""_Processing_Details.txt"

printf "Command Run: mkdir -p $computername/LiveResponseData/Logs/var\n"
printf "Command Run: mkdir -p $computername/LiveResponseData/Logs/var\n" >> "$computername/$computername""_Processing_Details.txt"
mkdir -p $computername/LiveResponseData/Logs/var >> "$computername/$computername""_Processing_Details.txt" 2>&1
printf "\n\n" >> "$computername/$computername""_Processing_Details.txt"

printf "Command Run: mkdir -p $computername/LiveResponseData/Logs/cron\n"
printf "Command Run: mkdir -p $computername/LiveResponseData/Logs/cron\n" >> "$computername/$computername""_Processing_Details.txt"
mkdir -p $computername/LiveResponseData/Logs/cron >> "$computername/$computername""_Processing_Details.txt" 2>&1
printf "\n\n" >> "$computername/$computername""_Processing_Details.txt"


echo ""
echo "***** Completed running $modulename module *****"
echo ""
return