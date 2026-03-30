#!/bin/bash

# Get location from IP
location=$(curl -s "http://ip-api.com/json")
lat=$(echo "$location" | jq -r '.lat')
lon=$(echo "$location" | jq -r '.lon')

# Use Open-Meteo to get weather description
response=$(curl -s "https://api.open-meteo.com/v1/forecast?latitude=${lat}&longitude=${lon}&current_weather=true")
weathercode=$(echo "$response" | jq -r '.current_weather.weathercode')

# Map WMO weather codes to descriptions
case $weathercode in
    0) desc="CLEAR SKY" ;;
    1) desc="MAINLY CLEAR" ;;
    2) desc="PARTLY CLOUDY" ;;
    3) desc="OVERCAST" ;;
    45|48) desc="FOGGY" ;;
    51|53|55) desc="DRIZZLE" ;;
    61|63|65) desc="RAIN" ;;
    71|73|75) desc="SNOW" ;;
    77) desc="SNOW GRAINS" ;;
    80|81|82) desc="RAIN SHOWERS" ;;
    85|86) desc="SNOW SHOWERS" ;;
    95) desc="THUNDERSTORM" ;;
    96|99) desc="THUNDERSTORM WITH HAIL" ;;
    *) desc="UNKNOWN" ;;
esac

echo "$desc"
