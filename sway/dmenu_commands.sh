#!/bin/sh

# Usage:
# Force cache generation: dmenu_commands -c
# Use cache / generate if needed: dmenu_commands

cache() {
	previous=""
	skip=false

	# Items in PATH
	path_items=$(echo $PATH | sed -e 's/:/ /g')
	for item in $path_items; do
		#Check if is symlink to something already in path
		link_path=$(readlink -fn $item)
		if [ "$link_path" != "$item" ]; then
			for link_item in $path_items; do
				if [ "$link_path" = "$link_item" ]; then
					skip=true
					break
				fi
			done
		fi

		if ! $skip; then
			previous="$(ls -1 $item)\n$previous"
		fi

		skip=false
	done

	# User defined functions
	for item in $(grep '()$' /home/voidbert/.dashrc | sed 's/()$//g'); do
		previous="$item\n$previous"
	done

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
