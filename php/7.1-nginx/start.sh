#!/bin/bash

# Starts FPM
sudo nohup /usr/sbin/php-fpm7.1 -F -O 2>&1 &

# Starts nginx!
sudo nginx
