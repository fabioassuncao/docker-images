#!/bin/bash
set -e

# Starts apache2
exec /usr/sbin/apache2ctl -D FOREGROUND "$@"