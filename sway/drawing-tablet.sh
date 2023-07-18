#!/bin/sh

# ----------------------------------- ABOUT -----------------------------------
#
# Asks to user to choose the mapping area of the drawing tablet.
#
# ---------------------------------- SCRIPT ----------------------------------

region="$(slurp -f "%x %y %w %h" -a 16:9 2>&1)"
# Check if the region is valid first (RegEx check)
if echo "$region" 2>&1 | grep -Eq "^[0-9]+ [0-9]+ [0-9]+ [0-9]+"; then
	swaymsg input "1386:891:Wacom_One_by_Wacom_M_Pen" map_to_region "$region"
	notify-send "Drawing area set"
else
	# Check if exiting slurp was voluntary or not
	if ! [ "$region" = "selection cancelled" ]; then
		notify-send -u critical Screenshot "slurp command failed"
	fi
	exit 1
fi

