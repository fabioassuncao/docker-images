#!/usr/bin/env bash

echo -e "# Preparing and Installing PHP"
echo "deb http://packages.sury.org/php/ jessie main" > /etc/apt/sources.list.d/php.list
wget -O /etc/apt/trusted.gpg.d/php.gpg https://packages.sury.org/php/apt.gpg

apt-get update -y
apt-get install -y --no-install-recommends \
    php7.1-apcu \
    php7.1-bcmath \
    php7.1-bz2 \
    php7.1-cli \
    php7.1-curl \
    php7.1-fpm \
    php7.1-gd \
    php7.1-imagick \
    php7.1-imap \
    php7.1-intl \
    php7.1-json \
    php7.1-mbstring \
    php7.1-mcrypt \
    php7.1-mysql \
    php7.1-mongodb \
    php7.1-opcache \
    php7.1-pgsql \
    php7.1-redis \
    php7.1-soap \
    php7.1-sqlite3 \
    php7.1-xdebug \
    php7.1-xml \
    php7.1-zip \
    php7.1-phpdbg

echo -e "# Configuring PHP"
sed -i "/user = .*/c\user = ${USER_NAME}" /etc/php/7.1/fpm/pool.d/www.conf
sed -i "/^group = .*/c\group = ${USER_GROUP}" /etc/php/7.1/fpm/pool.d/www.conf
sed -i "/listen.owner = .*/c\listen.owner = ${USER_NAME}" /etc/php/7.1/fpm/pool.d/www.conf
sed -i "/listen.group = .*/c\listen.group = ${USER_GROUP}" /etc/php/7.1/fpm/pool.d/www.conf
sed -i "/listen = .*/c\listen = [::]:9000" /etc/php/7.1/fpm/pool.d/www.conf
sed -i "/;access.log = .*/c\access.log = /proc/self/fd/2" /etc/php/7.1/fpm/pool.d/www.conf
sed -i "/;clear_env = .*/c\clear_env = no" /etc/php/7.1/fpm/pool.d/www.conf
sed -i "/;catch_workers_output = .*/c\catch_workers_output = yes" /etc/php/7.1/fpm/pool.d/www.conf
sed -i "/pid = .*/c\;pid = /run/php/php7.1-fpm.pid" /etc/php/7.1/fpm/php-fpm.conf
sed -i "/;daemonize = .*/c\daemonize = yes" /etc/php/7.1/fpm/php-fpm.conf
sed -i "/error_log = .*/c\error_log = /proc/self/fd/2" /etc/php/7.1/fpm/php-fpm.conf
sed -i "/post_max_size = .*/c\post_max_size = 1000M" /etc/php/7.1/fpm/php.ini
sed -i "/upload_max_filesize = .*/c\upload_max_filesize = 1000M" /etc/php/7.1/fpm/php.ini
sed -i "/zend_extension=xdebug.so/c\;zend_extension=xdebug.so" /etc/php/7.1/mods-available/xdebug.ini

echo -e "# Installing Composer"
curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

echo -e "# Cleaning up"
apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /usr/share/doc/*