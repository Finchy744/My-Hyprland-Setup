#!/bin/bash

updates=$(checkupdates 2>/dev/null | wc -l)
if [[ "$updates" -gt 0 ]]; then
  echo "{\"text\": \"⬆️ $updates updates\", \"tooltip\": \"You have $updates updates pending.\"}"
else
  echo "{\"text\": \"✅ Up to date\", \"tooltip\": \"Your system is fully updated.\"}"
fi
