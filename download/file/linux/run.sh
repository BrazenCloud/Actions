#!/bin/sh

cd "${0%/*}"

pythonCMD="python"

if ! [ -x "$(command -v python)" ]; then
    # no python installed
    pythonCMD="./python"
    chmod +x $pythonCMD 
fi

chmod +x ./runway.bin

$pythonCMD download_result.py 

