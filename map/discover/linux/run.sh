cd "${0%/*}"

chmod +x ./runway.bin

./runway.bin -N discover --json map.out
./runway.bin -N upload --map map.out