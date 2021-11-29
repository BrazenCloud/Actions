#!/bin/sh

response=""

if [ -z "$1" ]; then
        response="Missing required parameter (Process ID)" >&2
        echo "$response"
        exit 1
fi

rm -rf "$1"
rm -f $1-memory-dump.tar.gz
mkdir "$1"

cat /proc/$1/maps | grep "rw-p" | awk '{print $1}' | ( IFS="-"
while read a b; do
    dd if=/proc/$1/mem bs=$( getconf PAGESIZE ) iflag=skip_bytes,count_bytes skip=$(( 0x$a )) count=$(( 0x$b - 0x$a )) of="$1/$1_mem_$a.bin"  >/dev/null 2>&1

done )

tar -czvf $1-memory-dump.tar.gz $1 >/dev/null 2>&1
rm -rf $1

if [ -f "$1-memory-dump.tar.gz" ]; then
    echo "{\"Message\": \"Created file $1-memory-dump.tar.gz for process $1\", \"Successful\": True }"
else
   echo "{\"Message\": \"Unable to create memory dump for process $1\", \"Successful\": True }"
fi
