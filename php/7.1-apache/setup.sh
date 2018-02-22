#!/usr/bin/env bash

# Install apache2 from official repositories
echo -e "# Adding contrib and non-free components in source.list"
sed -i "/main/s//main contrib non-free/" /etc/apt/sources.list

echo -e  "# Updating Repository and Installing Apache2"
apt-get update -y
apt-get install -y --no-install-recommends \
    apache2 \
    apache2-mpm-worker \
    libapache2-mod-fastcgi
    
echo -e "# Disabling mods we don't need, and enabling those who need"
a2dismod mpm_prefork mpm_event
a2enmod actions fastcgi alias mpm_worker rewrite

echo -e "# Creating php7-fcgi"
touch /var/lib/apache2/fastcgi/php7-fcgi

echo -e "# Fixing permissions"
chown -R ${USER_NAME}:${USER_GROUP} /etc/apache2
chown -R ${USER_NAME}:${USER_GROUP} /var/run/apache2
chown -R ${USER_NAME}:${USER_GROUP} /var/log/apache2
chown -R ${USER_NAME}:${USER_GROUP} /var/lock/apache2
chown -R ${USER_NAME}:${USER_GROUP} /var/lib/apache2

echo -e "# Cleaning up"
apt-get clean
rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /usr/share/doc/*