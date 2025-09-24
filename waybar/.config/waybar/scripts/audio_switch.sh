#! /bin/bash

SPEAKER="alsa_output.usb-BEHRINGER_UMC202HD_192k-00.HiFi__Line1__sink"
HEADSET="alsa_output.usb-Schiit_Audio_Schiit_Unison_Modius-00.analog-stereo"

get_id() {
  local device=$1
  local line=$(wpctl status -n | tr -d '*' | grep "$device")

  echo "$line" | awk '{print $2'} | grep -o '^[0-9]*'
}

get_active() {
  local device=$1
  local line=$(wpctl status -n | grep "$device" | grep "*")


  if [ "$line" = "" ]; then
    echo False
  else
    echo True
  fi
}

get_icon() {
  if [ "$(get_active $SPEAKER)" = "True" ]; then
    echo 󰓃
  else
    echo 󰋋
  fi
}

switch() {
  if [ "$(get_active $SPEAKER)" = "True" ]; then
    wpctl set-default $(get_id $HEADSET)
  else
    wpctl set-default $(get_id $SPEAKER)
  fi
}


while getopts "s" opt; do
  case $opt in
  s) switch && exit ;;
	\?) echo "Invalid option -$OPTARG" >&2; exit 1 ;;
  esac
done

get_icon