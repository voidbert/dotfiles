#!/bin/sh

# --------------------------------------------- ABOUT ---------------------------------------------
#
# A cron job to automatically mount a USB stick that sometimes gets disconnected from the server.
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
# -------------------------------------------- SCRIPT --------------------------------------------
changequote(`«', `»')
. ./signal.sh
return_code=0

partition=$(readlink -e "/dev/disk/by-uuid/__USB_UUID__" 2> /dev/null)
if [ $? -eq 0 ]; then
    if ! mount | grep -q "$partition"; then
        text_message="USB stick was unmounted but auto-mount succeeded!"
        if ! doas -n /usr/bin/mount -U '__USB_UUID__'; then
            text_message="USB stick was unmounted and auto-mount failed! Admin action is needed!"
            return_code=1
        fi
    fi
else
    text_message="USB stick is unplugged! Admin action is needed!"
    return_code=1
fi

if [ -n "$text_message" ]; then
    echo "$text_message" 1>&2

    second_log_message=$(send_signal_message "$text_message")
    if [ $? -ne 0 ]; then
        echo "$second_log_message" 1>&2
        return_code=1
    fi
fi

exit "$return_code"
