#!/bin/sh

cd "${0%/*}"

chmod +x ./lynis/lynis

./lynis/lynis audit system