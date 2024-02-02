#!/bin/bash

ini_file="$XDG_RUNTIME_DIR/labwc/disp-bright.ini"
bright_api_dir="/sys/class/backlight/intel_backlight" # change your backlight driver here
bright_api_file="$bright_api_dir/brightness"
max_bright_api_file="$bright_api_dir/max_brightness"
notify_icon="~/.local/share/icons/disp-bright.svg"

cur=$(cat $brightness)
max=$(cat $max_brightness)
val=$(( 100 * $cur / $max ))

if [[ $1 == "+" ]]; then
    val=$(( $val + 5 ))
    if (( $val > 100 )); then
        val=100
    fi
elif [[ $1 == "-" ]]; then
    val=$(( $val - 5 ))
    if (( $val < 1 )); then
        val=1
    fi
fi

echo $(( $val * $max / 100 )) > $brightness

# if dbus has user session
if [[ -f $XDG_RUNTIME_DIR/bus ]]; then
	# process 1% of brightness as 0%
	# because 0% is absolute black screen
	if (( $val == 1 )); then
        	val=0
        fi

	# replace previous notification
	if [[ -f $ini_file ]]; then
		source $ini_file
		notify_id_cmd="-r $notify_id"
	fi

	notify_id=$(libnotify-notify-send $notify_id_cmd -i $notify_icon -h int:value:$val -p " ")
	echo "notify_id=$notify_id" > $ini_file
fi
