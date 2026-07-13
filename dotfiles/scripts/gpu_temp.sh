#!/bin/bash

TEMP=$(nvidia-smi --query-gpu=temperature.gpu --format=csv,noheader,nounits | head -n1)
echo "${TEMP}°C"

