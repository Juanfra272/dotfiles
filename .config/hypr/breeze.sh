#!/bin/bash

# Get location from IP
location=$(curl -s "http://ip-api.com/json")
lat=$(echo "$location" | jq -r '.lat')
lon=$(echo "$location" | jq -r '.lon')

# Use Open-Meteo to get humidity
response=$(curl -s "https://api.open-meteo.com/v1/forecast?latitude=${lat}&longitude=${lon}&current=relative_humidity_2m")
humidity=$(echo "$response" | jq -r '.current.relative_humidity_2m')

if [ -n "$humidity" ] && [ "$humidity" != "null" ]; then
    echo "${humidity}%"
else
    echo "0%"
fi
