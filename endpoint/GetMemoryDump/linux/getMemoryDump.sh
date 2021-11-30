#!/bin/sh

response=""
host=$(hostname)

rm -rf memorydump
rm -f physical-memory-dump.tar.gz
mkdir memorydump

cd memorydump
# download memdump deb file
wget http://launchpadlibrarian.net/212978437/memdump_1.01-7_amd64.deb

# install memdump from deb file
dpkg -i memdump_1.01-7_amd64.deb

# delete deb file
rm memdump_1.01-7_amd64.deb

# run memdump
memdump -m memorydump/physical-memory-dump

tar -czvf physical-memory-dump.tar.gz memorydump >/dev/null 2>&1
rm -rf memorydump

if [ -f "physical-memory-dump.tar.gz" ]; then
    echo "{\"Message\": \"Created file physical-memory-dump.tar.gz for $host.\", \"Successful\": True , \"File\": \"physical-memory-dump.tar.gz\"}"
else
   echo "{\"Message\": \"Unable to create memory dump for $host.\", \"Successful\": False }"
fi
