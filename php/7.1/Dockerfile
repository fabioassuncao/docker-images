###
# fabioassuncao/docker-images
#
# This Dockerfile was modified by Fábio Assunção <fabio23gt@gmail.com>
# Date 2018-01-23
# See the original in https://github.com/codecasts/ambientum
#
# Repository:    PHP
# Image:         CLI/Base
# Version:       7.1.x
# Strategy:      Debian Jessie as Base Image (Dotdeb PHP builds)
# Base distro:   debian:jessie
#
FROM debian:jessie

MAINTAINER Fábio Assunção <fabio23gt@gmail.com>

# Variable for enabling XDEBUG
ENV XDEBUG_ENABLED=false

# Install utility programs
RUN echo "# Updating Repository" && \
    apt-get update -y && \
    dpkg-reconfigure -f noninteractive tzdata && \
    apt-get upgrade -y && \
    apt-get install -y apt-transport-https \
    curl \
    libxrender1 \
    libfontconfig1 \
    libxext6 \
    wget \
    nano \
    vim \
    sudo

# Install PHP From DotDeb, Common Extensions
RUN echo "# Preparing and Installing PHP" && \
    echo "deb http://packages.sury.org/php/ jessie main" > /etc/apt/sources.list.d/php.list && \
    wget -O /etc/apt/trusted.gpg.d/php.gpg https://packages.sury.org/php/apt.gpg && \
    apt-get update -y && \
    apt-get -y install \
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

# Install Composer and then cleanup
RUN echo "# Installing Composer" && \
    curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer && \
    echo "# Cleaning up" && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /usr/share/doc/*

# Adding the docker-user
RUN echo "# Adding the docker-user" && \
    adduser --disabled-password --gecos "" docker-user && \
    mkdir -p /var/www/app && \
    chown -R docker-user:docker-user /var/www

# Add the ENTRYPOINT script
ADD start.sh /scripts/start.sh

RUN echo "# Configuring PHP" && \
    echo "docker-user  ALL = ( ALL ) NOPASSWD: ALL" >> /etc/sudoers && \
    sed -i "/user = .*/c\user = docker-user" /etc/php/7.1/fpm/pool.d/www.conf && \
    sed -i "/^group = .*/c\group = docker-user" /etc/php/7.1/fpm/pool.d/www.conf && \
    sed -i "/listen.owner = .*/c\listen.owner = docker-user" /etc/php/7.1/fpm/pool.d/www.conf && \
    sed -i "/listen.group = .*/c\listen.group = docker-user" /etc/php/7.1/fpm/pool.d/www.conf && \
    sed -i "/listen = .*/c\listen = [::]:9000" /etc/php/7.1/fpm/pool.d/www.conf && \
    sed -i "/;access.log = .*/c\access.log = /proc/self/fd/2" /etc/php/7.1/fpm/pool.d/www.conf && \
    sed -i "/;clear_env = .*/c\clear_env = no" /etc/php/7.1/fpm/pool.d/www.conf && \
    sed -i "/;catch_workers_output = .*/c\catch_workers_output = yes" /etc/php/7.1/fpm/pool.d/www.conf && \
    sed -i "/pid = .*/c\;pid = /run/php/php7.1-fpm.pid" /etc/php/7.1/fpm/php-fpm.conf && \
    sed -i "/;daemonize = .*/c\daemonize = yes" /etc/php/7.1/fpm/php-fpm.conf && \
    sed -i "/error_log = .*/c\error_log = /proc/self/fd/2" /etc/php/7.1/fpm/php-fpm.conf && \
    sed -i "/post_max_size = .*/c\post_max_size = 1000M" /etc/php/7.1/fpm/php.ini && \
    sed -i "/upload_max_filesize = .*/c\upload_max_filesize = 1000M" /etc/php/7.1/fpm/php.ini && \
    sed -i "/zend_extension=xdebug.so/c\;zend_extension=xdebug.so" /etc/php/7.1/mods-available/xdebug.ini

RUN chmod +x /scripts/start.sh && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /usr/share/doc/*

# Dumb Init
ADD https://github.com/krallin/tini/releases/download/v0.10.0/tini /tini
RUN chmod +x /tini

# Define the running user
USER docker-user

# Application directory
WORKDIR "/var/www/app"

ENV PATH=/home/docker-user/.composer/vendor/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

# Define the entry point
ENTRYPOINT ["/tini", "--", "/scripts/start.sh"]

# As non daemon and single base image, it may be used as cli container
CMD ["/bin/bash"]