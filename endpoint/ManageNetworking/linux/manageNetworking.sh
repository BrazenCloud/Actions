#!/bin/sh

while getopts e:p:d:i:a: flag
do
    case "${flag}" in
        e) enable=${OPTARG};;
        p) port=${OPTARG};;
        d) direction=${OPTARG};;
        i) ipaddress=${OPTARG};;
        a) action=${OPTARG};;
    esac
done

response=""

if [ -z "$enable" ] || [ -z "$port" ] || [ -z "$direction" ] || [ -z "$action" ]; then
        response="Missing required parameters (-e, -p, -d and -a are all required)" >&2
        echo "$response"
        exit 1
fi

rule="$port $action $direction $ipaddress"

if [ -z "$ipaddress" ]; then
   rule="$port $action $direction Anywhere"
fi

installed=$(dpkg-query -W -f='${Status}' ufw 2>/dev/null | grep -c "ok installed")

if [ $installed=1 ]; then
   status_response=$(ufw status numbered)
   ufw_enabled=true
   while read line ; do
      if [[ "$line" =~ .*"Status".* ]]; then
         if [[ "$line" =~ .*"inactive".* ]]; then
            response="Unable to continue, ufw is disabled"
            ufw_enabled=false
            break
         fi
      fi
   done <<< "$status_response"
   if [ "$ufw_enabled" = true ]; then
      response="ufw is enabled"
      # if the rule exists it will be updated
      if [ "$enable" = "true" ]; then
         response="$response.  Enabling rule: $rule"
         action=$(echo "$action" | tr '[:upper:]' '[:lower:]')
         direction=$(echo "$direction" | tr '[:upper:]' '[:lower:]')
         port=$(echo "$port" | tr '[:upper:]' '[:lower:]')
         if [ -z "$ipaddress" ]; then
            # ufw allow in 22
            # ufw deny out 3000
            result=$(ufw $action $direction $port)
         else
            if [ "$direction" = "IN" ]; then
               # ufw allow from 5.183.9.42 to any port 3000
               result=$(ufw $action from $ipaddress to any port $port)
            else
               # ufw allow out from any to 5.183.9.42 port 3000
               result=$(ufw $action out from any to $ipaddress port $port)
            fi         
         fi
         result=$(echo "$result" | sed -z 's/\n/\.  /g;s/\.  $/\n/')
         response="$response.  $result.  "
      else
         response="$response.  Disabling rule: $rule"
         nums_to_delete=()
         while read line ; do
            line=$(echo "$line"  | sed 's/[][]//g')
            if [ -z "$ipaddress" ]; then
               if [[ "$line" =~ .*"$port".*"$action".*"$direction".*"Anywhere".* ]]; then
                  IFS=" " read -r -a array <<< "$line"
                  rule_split=$(IFS=' ' read -r -a array <<< "$line")
                  rule_number="$array"
                  nums_to_delete+=( "$rule_number" )
               fi
            else
               if [[ "$line" =~ .*"$ipaddress".*"$action".*"$direction".*"$port" ]] ||
                  [[ "$line" =~ .*"$ipaddress".*"$port".*"$action".*"$direction".*"Anywhere" ]]; then
                  IFS=" " read -r -a array <<< "$line"
                  rule_split=$(IFS=' ' read -r -a array <<< "$line")
                  rule_number="$array"
                  nums_to_delete+=( $rule_number )
               fi
            fi
         done <<< "$status_response"
         number_matching_rules=${#nums_to_delete[@]}
         if [ $number_matching_rules -gt 0 ]; then
            IFS=$' ' sorted_nums_to_delete=($(sort <<<"${nums_to_delete[*]}"))
            unset IFS
            # iterate in reverse order so the rule numbers are not update (e.g. delete 4 and 9 becomes 8)
            for (( idx=${#sorted_nums_to_delete[@]}-1 ; idx>=0 ; idx-- )) ; do
               result=$(ufw --force delete "${sorted_nums_to_delete[idx]}")
               response="$response.  $result"
            done
         else
            response="$response.  No matching rules to delete."
         fi
      fi
   fi
else
   response="Unable to perform action, ufw is not installed"
fi

echo "$response"
