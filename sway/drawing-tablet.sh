#!/bin/sh

# ----------------------------------- ABOUT -----------------------------------
#
# Asks to user to choose the mapping area of the drawing tablet.
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

