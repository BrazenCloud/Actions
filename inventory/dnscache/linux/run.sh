cd "${0%/*}"

# write nscd cache stats to dns_cache
nscd -g >> ../results/dns_cache.txt

#Extract nscd from hosts files
strings /var/cache/nscd/hosts >> ../results/dns_cache.txt
strings /var/db/nscd/hosts >> ../results/dns_cache.txt

#extract systemd-resolved cache from logs
sdcachepid=$(pidof systemd-resolved)
echo $sdcachepid
pkill -USR1 $sdcachepid
journalctl -u systemd-resolved --since="2 minutes ago" --identifier=systemd-resolved --output-fields=MESSAGE >> ../results/dns_cache.txt
