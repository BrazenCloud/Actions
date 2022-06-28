cd "${0%/*}"

nscd -g > > ../results/dns_cache.txt
strings /var/cache/nscd/hosts > > ../results/dns_cache.txt
sdcachepid=$(pidof systemd-resolved)
echo $sdcachepid
sudo pkill -USR1 $sdcachepid
sudo journalctl -u systemd-resolved --since="2 minutes ago" --identifier=systemd-resolved --output-fields=MESSAGE > ../results/dns_cache.txt > > ../results/dns_cache.txt
