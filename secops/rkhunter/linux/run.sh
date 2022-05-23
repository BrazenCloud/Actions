#!/bin/sh

cd "${0%/*}"

chmod +x ./installer.sh

./installer.sh --install

rkhunter --check --sk --logfile ../results/rkhunter.log --nocolors