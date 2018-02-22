#!/usr/bin/env bash

# Install nginx from dotdeb (already enabled on base image)
echo -e "# Updating Repository and Installing Nginx"
apt-get update -y
apt-get install -y nginx

echo -e "# Fixing permissions"
mkdir /var/run/nginx
chown -R ${USER_NAME}:${USER_GROUP} /var/run/nginx
chown -R ${USER_NAME}:${USER_GROUP} /var/log/nginx
chown -R ${USER_NAME}:${USER_GROUP} /var/lib/nginx

echo -e "# Cleaning up"
apt-get clean
rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /usr/share/doc/*