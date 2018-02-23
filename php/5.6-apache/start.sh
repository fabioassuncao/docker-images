#!/bin/bash
set -e

if [ "$APACHE_ENVVARS" ]; then
	source "$APACHE_ENVVARS"
fi

# Apache gets grumpy about PID files pre-existing
: "${APACHE_PID_FILE:=${APACHE_RUN_DIR:=/var/run/apache2}/apache2.pid}"
rm -f "$APACHE_PID_FILE"

# Starts apache2!
exec apache2 -D FOREGROUND "$@"