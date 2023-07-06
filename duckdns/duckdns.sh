#!/bin/sh

# A script to update your IP in DuckDNS's servers, logging events to a file.

# ------------------------------- CONFIGURATION -------------------------------

# Comma-separated DuckDNS domains.
# E.g.: xxxxxx.duckdns.org and yyyyyy.duckdns.org becomes "xxxxxx,yyyyyy"
domains=""

# Your login token.
token=""

# The path to the log file. Leave empty for no logging.
log_file=""

# The path to a temporary file for curl output.
tmp_file="/tmp/duckdns"

# -----------------------------------------------------------------------------

url="https://www.duckdns.org/update?domains=$domains&token=$token&verbose=true"
http_code=$(curl -s -w "%{http_code}" -o "$tmp_file" "$url")
curl_code=$?

write=$(date +"%Y/%m/%d %H:%M:%S -")

if [ "$curl_code" -eq 0 ]; then
	if [ "$http_code" -eq 200 ]; then
		if [ "$(head -n 1 $tmp_file)" = "OK" ]; then # OK and KO message
			# Date - CHANGE/NOCHANGE (last lines) IP (2nd line)
			write="$write $(tail -n 1 $tmp_file) $(sed -n "2p" $tmp_file)"
			return_code=0
		else
			write="$write DuckDNS KO. Here's the response:\n$(cat $tmp_file)"
			return_code=1
		fi
	else
		write="$write HTTP CODE $http_code"

		# Don't print the response it it's empty
		pattern=$(printf '[^\s\r]') # printf for carriage return support
		if grep "$pattern" "$tmp_file"; then
			response=$(cat $tmp_file)
			write="$write. Here's the response:\n$response"
		fi

		return_code=1
	fi
else
	write="$write CURL RETURN VALUE $curl_code. See curl (1)"
	return_code=1
fi

if [ -n "$log_file" ]; then
	echo "$write" >> "$log_file"
fi
exit "$return_code"

