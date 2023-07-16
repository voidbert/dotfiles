#!/bin/sh

# Kills Xwayland periodically, when no windows are detected

must_kill=false

while true; do
	pid=$(pgrep Xwayland)
	if [ ! -z "$pid" ]; then
		# Xwayland is running

		shells=$(swaymsg -t get_tree | grep xwayland)
		if [ -z "$shells" ]; then
			# No windows detected. Kill Xwayland in the next iteration if there are no
			# windows then (because windows can be starting now)

			if $must_kill; then
				kill $pid
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

