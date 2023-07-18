#!/bin/bash

# ----------------------------------- ABOUT -----------------------------------
#
# Interactive script to attach an external monitor to a laptop. The script
# detects if the external monitor is being plugged in or unplugged.
#
# When plugging in displays, the user will be queried about the output
# resolution (based on available modes), and the placement of the display in
# relation to the laptop's screen. The displays will be center-aligned.
#
# ---------------------------------- LICENSE ----------------------------------
#
# Copyright 2023 Humberto Gomes
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
# ------------------------------- CONFIGURATION -------------------------------

# Width and height of the laptop's screen.
# It's assumed that it's normal position is 0, 0.
LAPTOP_WIDTH=1366
LAPTOP_HEIGHT=768

# Names of the internal and external displays
LAPTOP_NAME=eDP-1
EXTERNAL_NAME=HDMI-A-1

# ---------------------------------- SCRIPT ----------------------------------

# Lets the user choose an option from a list by inputting a number. Arguments:
#
# $1 - List elements, one per line
# $2 - Message (e.g.: 'Choose your favorite fruit:')
# $3 - Input prompt (e.g.: 'Fruit > ')
#
# The output is placed in the $result variable. It can't simply be printed
# because printing to stdout needs to happen for user interaction.
read_option() {
	# Message and numbered options
	echo "$2"
	echo "$1" | nl -w 3 -s ' > ' | cat
	echo ""

	element_count=$(echo "$1" | wc -l)

	# Read user input repeatedly until it's valid
	while true; do
		read -rp "$3" number

		if echo "$number" | grep -q '[^0-9]' ; then
			echo "Please input a number!"
		else
			if [ "$number" -ge 1 ]; then
				if [ "$number" -le "$element_count" ]; then
					result=$(echo "$1" | sed -n "${number}p")
					return 0
				fi
			fi
			echo "Number not in desired range!"
		fi
	done
}

# Given two dimensions $1 and $2 in an axis, this method will calculate the
# positions of the objects in that axis so that the smallest one is centered
# in the largest one. The position of the largest will always be 0.
#
# Example:
# $(align 1000 500) -> pos1=0, pos2=250
align() {
	if [ "$1" -ge "$2" ]; then
		pos1=0
		pos2=$((($1 - $2) / 2))
	else
		pos1=$((($2 - $1) / 2))
		pos2=0
	fi
}

# Centers the displays vertically (for left or right positioning).
center_vertically() {
	align "$external_height" "$LAPTOP_HEIGHT"
	external_y=$pos1
	laptop_y=$pos2
}

# Centers the displays horizontally (for top or bottom positioning).
center_horizontally() {
	align "$external_width" "$LAPTOP_WIDTH"
	external_x=$pos1
	laptop_x=$pos2
}

# Asks the user to configure the new display. The first and only argument must
# be the swaymsg output for the external display.
plug() {
	# Read display mode
	modes=$(echo "$1" | \
		jq -r '.modes[]? | "\(.width)x\(.height)@\(.refresh / 1000)Hz"' \
		| uniq)
	if [ -z "$modes" ] || [ -n "$(echo "$modes" | grep null)" ]; then
		echo "swaymsg didn't correctly report display modes. Wtf?"
		exit 1
	fi

	read_option "$modes" "Choose the display mode:" "Mode > "
	mode=$result
	echo ""

	# Read display position
	positions=$(printf "Top\nBottom\nLeft\nRight\n")
	read_option "$positions" \
		"Where is the external monitor in relation to the laptop's screen:" \
		"Position > "
	position=$result

	yes_no="$(printf "Yes\nNo")"
	read_option "$yes_no" "Do you want to share your wallpaper?" "? >"
	wallpaper=$result

	# Calculate positions of internal and external displays
	external_width=$(echo "$mode" | cut -dx -f1)
	external_height=$(echo "$mode" | cut -dx -f2 | cut -d@ -f1)

	laptop_x=0
	laptop_y=0
	external_x=0
	external_y=0

	if [ "$position" = "Top" ]; then
		laptop_y="$external_height"
		center_horizontally
	elif [ "$position" = "Bottom" ]; then
		external_y="$LAPTOP_HEIGHT"
		center_horizontally
	elif [ "$position" = "Left" ]; then
		laptop_x="$external_width"
		center_vertically
	elif [ "$position" = "Right" ]; then
		external_x="$LAPTOP_WIDTH"
		center_vertically
	fi

	# Determine wallpaper of external screen
	if [ "$wallpaper" = "Yes" ]; then
		wallpaper_path=$(ps -C swaybg -o args --no-headers | \
			awk -v FS="-o $LAPTOP_NAME -i |-m" '{ print $2 }')

		if [ -z "$wallpaper_path" ]; then
			echo "Unable to get current wallpaper. Defaulting to black."
			wallpaper_string='#000000 solid_color'
		else
			wallpaper_string="$wallpaper_path fill"
		fi
	else
		wallpaper_string='#000000 solid_color'
	fi

	swaymsg output "$LAPTOP_NAME"   position "$laptop_x" "$laptop_y" && \
	swaymsg output "$EXTERNAL_NAME" resolution "$mode" \
		position "$external_x" "$external_y" bg $wallpaper_string && \
	swaymsg output "$EXTERNAL_NAME" enable

	if [ $? -ne 0 ]; then
		echo "Something went wrong! Trying to reload config!"
		swaymsg reload
		exit 1
	fi

	echo "Display connected!"
}

# Disables the external display.
unplug() {
	swaymsg output "$EXTERNAL_NAME" disable && \
	swaymsg output "$LAPTOP_NAME"   position 0 0

	if [ $? -ne 0 ]; then
		echo "Something went wrong! Trying to reload config!"
		swaymsg reload
		exit 1
	fi

	echo "Display disconnected!"
}

# Get information about the external display
output_info=$(swaymsg -rt get_outputs | \
	jq ".[]? | select (.name? == \"$EXTERNAL_NAME\")")

if [ -z "$output_info" ]; then
	echo "No display connected!"
	echo "Maybe swaymsg didn't correctly report outputs?"
	exit 1
fi

# Determine if the display is being plugged or unplugged
output_active=$(echo "$output_info" | jq '.active?')

if [ "$output_active" = "false" ]; then
	plug "$output_info"
elif [ "$output_active" = "true" ]; then
	unplug
else
	echo "swaymsg didn't report an active / inactive status. Wtf?"
	exit 1
fi

