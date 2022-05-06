#!/bin/sh

cd "${0%/*}"

chmod +x ./lynis

./lynis audit system