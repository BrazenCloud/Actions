#!/bin/sh

if ! [ -x "$(command -v pwsh)" ]; then
    # no powershell installed
    echo No PowerShell is installed. Unable to continue.
else
    pwsh -Executionpolicy Bypass -File ./linux/installModules.ps1
fi