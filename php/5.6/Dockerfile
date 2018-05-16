###
# codions/docker-images
#
# Repository:    PHP
# Image:         CLI/Base
# Version:       5.6.x
# Strategy:      Ubuntu 16.04
# Base distro:   codions/ubuntu:16.04
#
FROM codions/ubuntu:16.04

MAINTAINER Fábio Assunção <fabio23gt@gmail.com>

# Reset user to root to allow software install
USER root

# Environment variables
ENV PATH=/home/${USER_NAME}/.composer/vendor/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

ENV COMPOSER_ALLOW_SUPERUSER=1

# Provisioning
RUN echo $'\n\n'"# Preparing and installing PHP"$'\n' && \
    LC_ALL=C.UTF-8 add-apt-repository ppa:ondrej/php && \
    apt-get update -y && \
	apt-get install -y --no-install-recommends \
    imagemagick \
    graphicsmagick \
    php5.6 \
    php5.6-bcmath \
    php5.6-bz2 \
    php5.6-cli \
    php5.6-common \
    php5.6-curl \
    php5.6-dba \
    php5.6-gd \
    php5.6-gmp \
    php5.6-imap \
    php5.6-intl \
    php5.6-ldap \
    php5.6-mbstring \
    php5.6-mcrypt \
    php5.6-mysql \
    php5.6-odbc \
    php5.6-pgsql \
    php5.6-recode \
    php5.6-soap \
    php5.6-sqlite \
    php5.6-tidy \
    php5.6-xml \
    php5.6-xmlrpc \
    php5.6-xsl \
    php5.6-zip \
    php-gnupg \
    php-imagick \
    php-mongodb \
    php-streams \
    php-fxsl && \
    echo $'\n\n'"# Installing Composer"$'\n' && \
	curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer && \
    echo $'\n\n'"# Cleaning up"$'\n' && \
	apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /usr/share/doc/*

# Add the ENTRYPOINT script
ADD start.sh /scripts/start.sh
RUN chmod +x /scripts/start.sh

# Define the running user
USER $USER_NAME

# Application directory
WORKDIR $WORKDIR

# Define the entry point
ENTRYPOINT ["/tini", "--", "/scripts/start.sh"]

# As non daemon and single base image, it may be used as cli container
CMD /bin/bash