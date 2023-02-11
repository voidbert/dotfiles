#!/bin/sh

if mkdir /tmp/sway_sleep.lock; then
	doas /bin/zzz
	swaymsg mode default
	sleep 5
	rm -r /tmp/sway_sleep.lock
fi
