#!/bin/sh

# --------------------------------------------- ABOUT ---------------------------------------------
#
# A cron job to update a dynamic IP address in DuckDNS's servers.
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
http_response_payload=$(mktemp)
http_response_code=$(curl -s -w '%{http_code}' -o "$http_response_payload" \
    'https://www.duckdns.org/update?domains=__SERVER_DOMAIN__&token=__DUCKDNS_TOKEN__&verbose=true')
curl_exit_code=$?

text_message=$(date +'DuckDNS: %Y/%m/%d %H:%M:%S -')
return_code=1

if [ "$curl_exit_code" -ne 0 ]; then
    text_message="$text_message curl exited with $curl_exit_code. See \`man 1 curl\`."

elif [ "$http_response_code" -ne 200 ]; then
	text_message="$text_message HTTP CODE $http_response_code."
    text_message="$text_message Response:\n$(cat "$http_response_payload")"

elif [ "$(head -n1 "$http_response_payload")" != "OK" ]; then
	text_message="$text_message $(cat "$http_response_payload")"

else
    return_code=0
	text_message="$text_message $(tail -n1 "$http_response_payload")"
    text_message="$text_message $(sed -n "2p" "$http_response_payload")"
    [ "$(tail -n1 "$http_response_payload")" = "NOCHANGE" ] && unset text_message
fi

if [ -n "$text_message" ]; then
    echo "$text_message" 1>&2
    ./signal/signal.sh send "$text_message"
fi

rm "$http_response_payload"
exit "$return_code"
