#! /bin/bash

if [ -z "$1" ]; then
	echo "usage: single_request_webserver.sh <port>"
	exit 1
fi

echo -e "HTTP/1.1 200 OK\n\n $(date)" | nc -l -p "$1"
