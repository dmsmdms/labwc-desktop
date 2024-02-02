#!/bin/bash

ini_file="$XDG_RUNTIME_DIR/labwc/kbd-layout.ini"
lang_arr=("English (US)" "Russian (RU)") # change your layouts here
lang_id=0
waybar_signal_id=1

if [[ -f $ini_file ]]; then
	source $ini_file
fi

if [[ $1 == "toggle" ]]; then
    lang_id=$(( $lang_id + 1 ))
    lang_id=$(( $lang_id % ${#lang_arr[@]} ))
    echo "lang_id=$lang_id" > $ini_file
    pkill -RTMIN+$waybar_signal_id waybar
else
    echo ${lang_arr[$lang_id]}
fi
