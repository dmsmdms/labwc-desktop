#!/bin/bash

waybar_signal_id=2

if [[ $1 == "+" ]]; then
	amixer -q sset Master on 5%+
elif [[ $1 == "-" ]]; then
	amixer -q sset Master on 5%-
elif [[ $1 == "mute" ]]; then
	amixer -q sset Master toggle
else
	res=$(amixer sget Master)
	val=$(echo $res | awk -F '[][]' '/Mono:/ { print $2 }' | tr -d '%')
	is_active=$(echo $res | awk -F 'dB]' '/Mono:/ { print $2 }')

	# audio is muted
	if [[ $is_active == *"off"* ]]; then
    		val=0
	fi

	# type of audio output
	# if [[ ]]; then
		icon=""
	# elif [[ ]]; then
		# icon=""
	# else
		# icon=""
	# fi

	# set style of muted audio
	if (( $val == 0 )); then
		class="disabled"
	fi

	printf '{"text": "%s", "class": "%s"}\n' "$val% $icon" "$class"
	exit
fi

pkill -RTMIN+$waybar_signal_id waybar
