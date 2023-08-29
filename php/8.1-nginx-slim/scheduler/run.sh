#!/usr/bin/env bash
set -e

while true; do
	if [ -d "/var/www/html/vendor" ] ; then
		printf " -----> Info: Running scheduled tasks.\n"
		php /var/www/html/artisan schedule:run --verbose --no-interaction >> /dev/null 2>&1 &
	else
		printf " -----> Warning: Directory /var/www/html/vendor does not yet exist.\n"
	fi
	sleep 60s
done
