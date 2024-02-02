#!/bin/bash

entries=" Shutdown\n Reboot\n Suspend"

selected=$(echo -e $entries | wofi -k /dev/null -c ~/.config/wofi/power.conf -s ~/.config/wofi/power.css | awk '{print tolower($2)}')

if [[ $selected == "shutdown" ]]; then
	su -c "poweroff"
elif [[ $selected == "reboot" ]]; then
	su -c "reboot"
elif [[ $selected == "suspend" ]]; then
	su -c "loginctl suspend"
fi
