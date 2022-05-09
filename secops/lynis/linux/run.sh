#!/bin/sh

chown -R 0:0 linux

cd "${0%/*}"

chmod -R u=rw,g=r,o=r ./

chmod +x ./lynis

./lynis audit system --log-file ../results/lynis.log --no-colors