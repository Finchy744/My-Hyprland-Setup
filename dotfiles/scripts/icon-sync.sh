#!/bin/bash

ICON=$(gsettings get org.gnome.desktop.interface icon-theme | tr -d "'")

kwriteconfig6 --file kdeglobals --group Icons --key Theme "$ICON"

kbuildsycoca6 --noincremental
