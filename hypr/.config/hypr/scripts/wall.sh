#!/bin/bash
# Directory containing wallpapers
HOME_DIR="/home/nev"
WALLPAPER_DIR="$HOME_DIR/Pictures/Wallpapers"
CONFIG_DIR="$HOME_DIR/.config/hypr"
while true; do
	# List files in the wallpaper directory and send them to wofi
	SELECTED=$(ls "$WALLPAPER_DIR"/*.{png,jpg,jpeg,gif,webp} 2>/dev/null | xargs -n 1 basename | wofi --dmenu --prompt "Select a wallpaper:" -W 300 -H 300)
	# Check if a selection was made
	if [ -n "$SELECTED" ]; then
		# Set the selected wallpaper using swww
		swww img $WALLPAPER_DIR/$SELECTED
	fi
	break
done
