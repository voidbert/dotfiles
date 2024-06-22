#!/bin/sh

# --------------------------------------------- ABOUT ---------------------------------------------
#
# Utility function for sending Signal messages with warnings.
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
# Sends a Signal message to my phone.
#
# $1 - Message contents
# stdout - Possible error message
# Return value - 0 or 1, whether the variable in $2 will have a value.
send_signal_message() {
    http_response_code=$( \
        curl -X 'POST' 'http://localhost:8080/v2/send' \
            -s -w '%{http_code}' -o '/dev/null' \
            -H 'accept: application/json' -H 'Content-Type: application/json' \
            -d '{
                "message": '"$(echo -n "$1" | jq -Rs)"',
                "number": "__SIGNAL_SOURCE__",
                "recipients": [
                    "__SIGNAL_DESTINATION__"
                ]
            }')
    curl_exit_code=$?

    if [ "$curl_exit_code" -ne 0 ]; then
        error_message="curl exited with $curl_exit_code. See \`man 1 curl\`."
    elif [ "$http_response_code" -ne 201 ]; then
        error_message="HTTP CODE $http_response_code."
    fi
    [ -n "$error_message" ] && echo "Signal error: $error_message" && return 1
    return 0
}
