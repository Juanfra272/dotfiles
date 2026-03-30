#!/bin/bash

# Updates city and weather cache files for hyprlock
# Run this at login or periodically

CITY_CACHE="$HOME/.cache/hyprlock_city"
WEATHER_CACHE="$HOME/.cache/hyprlock_weather"

# Get location
location=$(curl -s --connect-timeout 3 --max-time 5 "http://ip-api.com/json")
city=$(echo "$location" | jq -r '.city')
lat=$(echo "$location" | jq -r '.lat')
lon=$(echo "$location" | jq -r '.lon')

# Update city cache
if [ -n "$city" ] && [ "$city" != "null" ]; then
    echo "$city" | awk '{print toupper($0)}' > "$CITY_CACHE"
fi

# Get weather
response=$(curl -s --connect-timeout 3 --max-time 5 "https://api.open-meteo.com/v1/forecast?latitude=${lat}&longitude=${lon}&current_weather=true")
temperature=$(echo "$response" | jq -r '.current_weather.temperature')
rounded=$(printf "%.0f" "$temperature")

if [ -n "$rounded" ] && [ "$rounded" != "null" ]; then
    echo "${rounded}°C" > "$WEATHER_CACHE"
fi
