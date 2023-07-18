#!/bin/sh

# ----------------------------------- ABOUT -----------------------------------
#
# Takes a screenshot of an area specified through command-line arguments.
# Primarily used with sway's keyboard shortcuts.
#
# Usage: ./screenshot.sh [single option]
#
# Options:
# -a, --all: capture all monitors
# -c, --current: capture current monitor
# -w, --window: capture current window
# -r, --region: prompt the user to select the region to capture
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
# ---------------------------------- SCRIPT ----------------------------------

output_file="$(xdg-user-dir PICTURES)/Screenshot_$(date +"%Y-%m-%d_%H-%M-%S").png"

usage()
{
	echo ""
	echo "Usage: ./screenshot.sh [single option]"
	echo ""
	echo "Options:"
	echo "-a, --all: capture all monitors"
	echo "-c, --current: capture current monitor"
	echo "-w, --window: capture current window"
	echo "-r, --region: prompt the user to select the region to capture"
	echo ""
}

# The first argument must be the message to notify in case of success
success_check()
{
	if [ $? -eq 0 ]; then
		notify-send Screenshot "$1"
	else
		notify-send -u critical Screenshot "grim command failed"
		exit 1
	fi
}

if [ $# -eq 1 ]; then
	if [ "$1" = "-a" ] || [ "$1" = "--all" ]; then

		grim "$output_file"
		success_check "All monitors"

	elif [ "$1" = "-c" ] || [ "$1" = "--current" ]; then

		monitor="$(swaymsg -t get_outputs | jq -r '.[] | select(.focused) | .name')"
		grim -o "$monitor" "$output_file"
		success_check "Screenshot of the current monitor"

	elif [ "$1" = "-w" ] || [ "$1" = "--window" ]; then

		window="$(swaymsg -t get_tree | jq -j '.. | select(.type?) | select(.focused).rect | "\(.x),\(.y) \(.width)x\(.height)"')"
		grim -g "$window" "$output_file"
		notify-send "Screenshot of the current window"

	elif [ "$1" = "-r" ] || [ "$1" = "--region" ]; then

		region="$(slurp 2>&1)"

		# Check if the region is valid first (RegEx check)
		if echo "$region" 2>&1 | grep -Eq "^[0-9]+,[0-9]+ [0-9]+x[0-9]+"; then
			grim -g "$region" "$output_file"
			notify-send "Screenshot of the selected area"
		else
			# Check if exiting slurp was voluntary or not
			if ! [ "$region" = "selection cancelled" ]; then
                                notify-send -u critical Screenshot "slurp command failed"
                        fi
			exit 1
		fi

	else
		usage
	fi
else
	usage
fi

