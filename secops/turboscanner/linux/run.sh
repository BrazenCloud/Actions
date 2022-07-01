#!/bin/sh

cd "${0%/*}"

chmod +x ./turbo-scanner_010l

./turbo-scanner_010l localhost >> ../results/turboscanner.txt

