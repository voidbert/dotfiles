#!/bin/sh

# ----------------------------------- ABOUT -----------------------------------
#
# Sometimes, when putting the computer to sleep, sway will register multiple
# presses of the S key. After going to sleep and waking back up again, the
# 2nd press of the S key will be handled, putting the computer to sleep again.
#
# This script solves that issue by creating a lock for sleep.
#
# ---------------------------------- SCRIPT ----------------------------------

if mkdir /tmp/sway_sleep.lock; then
	doas /bin/zzz
	swaymsg mode default
	sleep 5
	rm -r /tmp/sway_sleep.lock
fi
