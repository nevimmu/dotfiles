#!/usr/bin/env bash

ICON_ON="󰒋"
ICON_OFF="󰒏"

while true; do
	temp=$(ssh maid0 'echo $(($(cat /sys/class/thermal/thermal_zone0/temp)/1000))')

	if [ ! -z $temp ]; then
		echo $ICON_ON $temp'°C'
	else
		echo $ICON_OFF
	fi

	sleep 10
done
