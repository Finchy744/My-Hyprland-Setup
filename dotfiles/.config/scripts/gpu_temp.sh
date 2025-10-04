#!/bin/bash
# Change hwmon2 and temp1_input if your GPU path differs

TEMP_RAW=$(cat /sys/class/hwmon/hwmon2/temp1_input)
TEMP_C=$((TEMP_RAW / 1000))

echo "${TEMP_C}°C"
