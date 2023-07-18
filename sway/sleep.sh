#!/bin/sh

# ----------------------------------- ABOUT -----------------------------------
#
# Sometimes, when putting the computer to sleep, sway will register multiple
# presses of the S key. After going to sleep and waking back up again, the
# 2nd press of the S key will be handled, putting the computer to sleep again.
#
# This script solves that issue by creating a lock for sleep.
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

if mkdir /tmp/sway_sleep.lock; then
	doas /bin/zzz
	if command -v swaylock; then swaylock -c 000000; fi
	swaymsg mode default
	sleep 5
	rm -r /tmp/sway_sleep.lock
fi
