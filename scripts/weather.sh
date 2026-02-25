#!/bin/bash

# --------------------------
# Auto-detect location using IP
# --------------------------
loc=$(curl -s https://ipinfo.io/json)
LAT=$(echo "$loc" | jq -r '.loc' | cut -d',' -f1)
LON=$(echo "$loc" | jq -r '.loc' | cut -d',' -f2)

# --------------------------
# Fetch weather from Open-Meteo
# --------------------------
weather_json=$(curl -s "https://api.open-meteo.com/v1/forecast?latitude=${LAT}&longitude=${LON}&current_weather=true&daily=temperature_2m_max,temperature_2m_min&temperature_unit=fahrenheit&timezone=auto")

# --------------------------
# Parse values
# --------------------------
current_temp=$(echo "$weather_json" | jq -r '.current_weather.temperature')
high_temp=$(echo "$weather_json" | jq -r '.daily.temperature_2m_max[0]')
low_temp=$(echo "$weather_json" | jq -r '.daily.temperature_2m_min[0]')
weather_code=$(echo "$weather_json" | jq -r '.current_weather.weathercode')

# Round temperatures to whole numbers
current_temp=$(printf "%.0f" "$current_temp")
high_temp=$(printf "%.0f" "$high_temp")
low_temp=$(printf "%.0f" "$low_temp")

# --------------------------
# Map weather codes to icons & conditions
# --------------------------
icon="🌡️"
condition="Unknown"

case $weather_code in
  0) icon="☀️"; condition="Clear" ;;
  1) icon="🌤️"; condition="Mainly Clear" ;;
  2) icon="⛅"; condition="Partly Cloudy" ;;
  3) icon="☁️"; condition="Overcast" ;;
  45|48) icon="🌫️"; condition="Fog" ;;
  51|53|55|56|57) icon="🌦️"; condition="Drizzle" ;;
  61|63|65|66|67) icon="🌧️"; condition="Rain" ;;
  71|73|75|77) icon="❄️"; condition="Snow" ;;
  80|81|82) icon="🌧️"; condition="Rain Showers" ;;
  95|96|99) icon="⛈️"; condition="Thunderstorm" ;;
esac

# --------------------------
# Output JSON for Waybar
# --------------------------
echo "{\"text\":\"$icon ${current_temp}°F\",\"tooltip\":\"$condition | High: ${high_temp}°F | Low: ${low_temp}°F\"}"
