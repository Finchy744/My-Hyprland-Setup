#!/bin/bash
text=$(/home/jordan/.config/scripts/updates.sh | jq -r .text)
notify-send "Update Status" "$text"
