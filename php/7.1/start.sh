#!/usr/bin/env bash

# This script was modified by Fábio Assunção <fabio23gt@gmail.com>
# Date 2018-01-22
# See the original in https://github.com/codecasts/ambientum/blob/master/php-old/7.1/start.sh

if [[ $XDEBUG_ENABLED == true ]]; then
    # enable xdebug extension
    sudo sed -i "/;zend_extension=xdebug.so/c\zend_extension=xdebug.so" /etc/php/7.1/mods-available/xdebug.ini

    # enable xdebug remote config
    echo "[xdebug]" | sudo tee -a /etc/php/7.1/mods-available/xdebug.ini
    echo "xdebug.remote_enable=1" | sudo tee -a /etc/php/7.1/mods-available/xdebug.ini
    echo "xdebug.remote_host=`/sbin/ip route|awk '/default/ { print $3 }'`" | sudo tee -a /etc/php/7.1/mods-available/xdebug.ini
    echo "xdebug.remote_port=9000" | sudo tee -a /etc/php/7.1/mods-available/xdebug.ini
    echo "xdebug.scream=0" | sudo tee -a /etc/php/7.1/mods-available/xdebug.ini
    echo "xdebug.cli_color=1" | sudo tee -a /etc/php/7.1/mods-available/xdebug.ini
    echo "xdebug.show_local_vars=1" | sudo tee -a /etc/php/7.1/mods-available/xdebug.ini
    echo 'xdebug.idekey = "ambientum"' | sudo tee -a /etc/php/7.1/mods-available/xdebug.ini

fi

# run the original command
exec "$@"