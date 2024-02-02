#!/bin/bash

ini_file="$XDG_RUNTIME_DIR/labwc/kbd-bright.ini"
bright_api_dir="/sys/class/leds/asus::kbd_backlight" # change your backlight driver here
bright_api_file="$bright_api_dir/brightness"
max_bright_api_file="$bright_api_dir/max_brightness"
notify_icon="~/.local/share/icons/kbd-bright.svg"

cur=$(cat $bright_api_file)
max=$(cat $max_bright_api_file)

if [[ $1 == "+" ]]; then
    cur=$(( $cur + 1 ))
    if (( $cur > $max )); then
        cur=$max
    fi
elif [[ $1 == "-" ]]; then
    cur=$(( $cur - 1 ))
    if (( $cur < 0 )); then
        cur=0
    fi
fi

echo $cur > $brightness

# if dbus has user session
if [[ -f $XDG_RUNTIME_DIR/bus ]]; then
	val=$(( 100 * $cur / $max ))

	# replace previous notification
	if [[ -f $ini_file ]]; then
		source $ini_file
		notify_id_cmd="-r $notify_id"
	fi

	notify_id=$(libnotify-notify-send $notify_id_cmd -i $notify_icon -h int:value:$val -p " ")
	echo "notify_id=$notify_id" > $ini_file
fi
