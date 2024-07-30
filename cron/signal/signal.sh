#!/bin/sh

# --------------------------------------------- ABOUT ---------------------------------------------
#
# Wrapper for running signal-cli inside its rootfs. Shortcuts exist to receive messages with
# automatic error reporting, and to send messages to my phone. It's also possible to run a raw
# signal-cli command.
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
# --------------------------------------------- SCRIPT ---------------------------------------------

# Runs signal-cli in its rootfs.
#
# $@ - signal-cli command-line options
# return - The exit code of signal-cli
signal_cli() {
    script_dir="$(dirname "$(realpath "$0")")"
    bwrap --bind "$script_dir/signal-cli-rootfs" / \
        --proc /proc \
        --dev /dev \
        --bind "$script_dir/signal-cli-data" /home/signal/.local/share/signal-cli \
        --chdir / \
        --unshare-user \
        --uid 1000 --gid 1000 \
        --clearenv \
        signal-cli "$@"
}

# Sends a Signal message to my phone. As an error ocurred in sending a message, errors don't get
# communicated via Signal messages, but are insteasd printed directly to stderr.
#
# $1 - Message contents
# return - 0 if successful, 1 if unsuccessful
signal_send_message() {
    error_message="Failed to send Signal message"
    if ! error_message="$error_message:$(signal_cli -a __SIGNAL_SOURCE__ send -m "$1" \
        __SIGNAL_DESTINATION__ 2>&1 > /dev/null)"; then

        echo "$error_message" 1>&2
        return 1
    fi

    return 0
}

# Receives Signal messages, which are ignored. Errors try to be communicated via signal messages
# and, if that fails, errors are printed to stderr.
#
# return - 0 if successful, 1 if unsuccessful
signal_receive_messages() {
    error_message="Failed to receive signal-cli messages"
    if ! error_message="$error_message: $(signal_cli -a __SIGNAL_SOURCE__ receive \
        2>&1 > /dev/null)"; then

        signal_send_message "$error_message" || echo "$error_message" 1>&2
        return 1
    fi

    return 0
}

if [ "$#" -eq 2 ] && [ "$1" = "send" ]; then
    signal_send_message "$2"
elif [ "$#" -eq 1 ] && [ "$1" = "receive" ]; then
    signal_receive_messages
elif [ "$1" = "signal-cli" ]; then
    shift
    signal_cli "$@"
else
    echo "Usage: $0 (send (message)|receive|signal-cli (command))" 1>&2
fi
