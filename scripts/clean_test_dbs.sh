#! /bin/sh

set -o errexit
set -o pipefail

psql -h 127.0.0.1 -Upostgres -c 'select datname from pg_database' \
	| grep 'test_' \
	| tr -d ' ' \
	| tee /dev/tty \
	| xargs -I_ psql -Upostgres -h 127.0.0.1 -c "drop database _"
