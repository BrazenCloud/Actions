streamName=$(jq -r '."Stream Name"' ./settings.json)
outputType=$(jq -r '."Output Type"' ./settings.json)
address=$(jq -r '."Address"' ./settings.json)
timeout=$(jq -r '."Timeout"' ./settings.json)
host=$(jq -r '."Host"' ./settings.json)

echo "Creating a $streamName stream of type '$outputType' listen to $address"

../../../runway -N -S $host stream --listen $streamName --output "$outputType://$address" --persistent