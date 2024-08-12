#!/bin/sh

# --------------------------------------------- ABOUT ---------------------------------------------
#
# Script to control screen brightness (/sys/class/backlight/intel_backlight).
#
# -------------------------------------------- LICENSE --------------------------------------------
#
# Copyright 2024 Humberto Gomes
#
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
# --------------------------------------------- SCRIPT --------------------------------------------

current_brightness="$(cat "/sys/class/backlight/intel_backlight/brightness")"

# Get the level closest to the current brightness
best_level="1000"
while IFS= read -r current_level; do
    current_delta="$((current_level - current_brightness))"
    [ "$current_delta" -lt 0 ] && current_delta="$((- current_delta))"

    best_delta="$((best_level - current_brightness))"
    [ "$best_delta" -lt 0 ] && best_delta="$((- best_delta))"

    [ "$best_delta" -ge "$current_delta" ] && best_level="$current_level"
done < "$HOME/.config/sway/brightness_levels"

if [ "$1" = "up" ]; then
    command="cat"
elif [ "$1" = "down" ]; then
    command="tac"
else
    echo "Usage: $0 (up|down)" 1>&2
    exit 1
fi

"$command" "$HOME/.config/sway/brightness_levels" | grep -s -A 1 "^$best_level\$" | tail -1 > \
    "/sys/class/backlight/intel_backlight/brightness"
