# check if ufw is installed
installed=$(dpkg-query -W -f='${Status}' ufw 2>/dev/null | grep -c "ok installed")

if ! which ufw > /dev/null; then
   echo -e "ufw not found!"
fi