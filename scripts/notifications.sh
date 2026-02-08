#!/bin/bash

# This can be replaced with more advanced logic if needed
if pgrep -x "mako" > /dev/null; then
    echo '{"text": "🔔", "tooltip": "Notifications Enabled"}'
else
    echo '{"text": "🔕", "tooltip": "Notifications Disabled"}'
fi
