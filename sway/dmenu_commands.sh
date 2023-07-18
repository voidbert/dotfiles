#!/bin/sh

# ----------------------------------- ABOUT -----------------------------------
#
# Lists all the commands in the system, including user-defined functions in
# .dashrc. Use ./dmenu_commands.sh -c to generate a command cache in
# /tmp/dmenu_command_cache, or ./dmenu_commands.sh to print the cache,
# generating if it doesn't exist.
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

cache() {
	previous=""
	skip=false

	# Items in PATH
	path_items=$(echo "$PATH" | sed -e 's/:/ /g')
	for item in $path_items; do
		#Check if is symlink to something already in path
		link_path=$(readlink -fn "$item")
		if [ "$link_path" != "$item" ]; then
			for link_item in $path_items; do
				if [ "$link_path" = "$link_item" ]; then
					skip=true
					break
				fi
			done
		fi

		if ! $skip; then
			previous="$(ls -1 "$item")\n$previous"
		fi

		skip=false
	done

	# User defined functions
	user_commands=$(grep '()$' /home/voidbert/.dashrc | sed 's/()$//g')
	previous=$(printf "%s\n%s" "$user_commands" "$previous")
	echo "$previous" | sed '/^$/d' | sort -u -o "/tmp/dmenu_command_cache"
}

if [ "$1" = "-c" ]; then
	cache
else
	if ! [ -e "/tmp/dmenu_command_cache" ]; then
		cache
	fi
	cat "/tmp/dmenu_command_cache"
fi

