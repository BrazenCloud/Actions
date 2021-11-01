#!/bin/sh

cd "${0%/*}"

pythonCMD="python3"

if ! [ -x "$(command -v python)" ]; then
    # no python installed
    pythonCMD="./python3"
    chmod +x $pythonCMD
fi

$pythonCMD GetFreeDiskSpace.py
