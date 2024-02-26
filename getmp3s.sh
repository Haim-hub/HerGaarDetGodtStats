#!/bin/bash

# Check if jq is installed on the system
if ! [ -x "$(command -v jq)" ]; then
    echo 'Error: jq is not installed.' >&2
    exit 1
fi

# Load JSON data from a file
json_data=$(cat ./episodes.JSON)

# Extract the ids where hasVideo is false
ids=$(echo "$json_data" | jq -r '.data.podcastEpisodes[] | select(.hasVideo == false) | .id')

# Output the ids to hasVideoFalse.txt
echo "$ids" >hasVideoFalse.txt

# Extract the ids where hasVideo is true
ids=$(echo "$json_data" | jq -r '.data.podcastEpisodes[] | select(.hasVideo == true) | .id')

# Output the ids to hasVideoTrue.txt
echo "$ids" >hasVideoTrue.txt

# https://cdn-web.podimo.com/audios/<id>.mp3?Expires=1708994204&KeyName=podimo-audio-web-player-key-2&Signature=apJKmdxmMIvIvG6Dij4trc93lC4
# Download the mp3s where the ids are in hasVideoFalse.txt
while read -r id; do
    wget -O "$id.mp3" "https://cdn-web.podimo.com/audios/$id.mp3?Expires=1708994204&KeyName=podimo-audio-web-player-key-2&Signature=apJKmdxmMIvIvG6Dij4trc93lC4"
done <hasVideoFalse.txt
