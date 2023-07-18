#!/bin/sh

# ----------------------------------- ABOUT -----------------------------------
#
# Kills Xwayland periodically, when no X windows are detected.
#
#---------------------------------- LICENSE ----------------------------------
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

must_kill=false

while true; do
	pid=$(pgrep Xwayland)
	if [ -n "$pid" ]; then
		# Xwayland is running

		shells=$(swaymsg -t get_tree | grep xwayland)
		if [ -z "$shells" ]; then
			# No windows detected. Kill Xwayland in the next iteration if there are no
			# windows then (because windows can be starting now)

			if $must_kill; then
				kill "$pid"
				must_kill=false
				notify-send -t 5000 "Killed Xwayland"
			else
				must_kill=true
			fi
		else
			must_kill=false
		fi
	fi

	sleep 60
done

