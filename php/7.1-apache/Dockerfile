###
# codions/docker-images
#
# Repository:    PHP
# Image:         CLI/Base
# Version:       7.1.x
# Strategy:      Debian Jessie as Base Image (Dotdeb PHP builds)
# Base distro:   debian:jessie
#
FROM codions/php:7.1

MAINTAINER Fábio Assunção <fabio23gt@gmail.com>

# Reset user to root to allow software install
USER root

# Install apache2 from official repositories
RUN echo "# Adding contrib and non-free components in source.list" && \
    sed -i "/main/s//main contrib non-free/" /etc/apt/sources.list && \
    echo "# Updating Repository and Installing Apache2" && \
    apt-get update -y && \
    apt-get install -y \
    apache2 \
    apache2-mpm-worker \
    libapache2-mod-fastcgi && \
    echo "# Disabling mods we don't need, and enabling those who need" && \
    a2dismod mpm_prefork mpm_event && \
    a2enmod actions fastcgi alias mpm_worker rewrite && \
    echo "# Creating php7-fcgi" && \
    touch /var/lib/apache2/fastcgi/php7-fcgi && \
    echo "# Cleaning up" && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /usr/share/doc/*

RUN echo "# Fixing permissions" && \
    chown -R codions:codions /var/run/apache2 && \
    chown -R codions:codions /var/log/apache2 && \
    chown -R codions:codions /var/lock/apache2 && \
    chown -R codions:codions /var/lib/apache2

# Copy apache, fastcgi and entry script
COPY configs/000-default.conf /etc/apache2/sites-available/000-default.conf
COPY configs/ports.conf /etc/apache2/ports.conf
COPY configs/fastcgi.conf /etc/apache2/mods-available/fastcgi.conf
COPY start.sh /home/codions/start.sh
COPY app /var/www/app

RUN chmod +x /home/codions/start.sh && \
    chown -R codions:codions /home/codions

# Define the running user
USER codions

# Application directory
WORKDIR "/var/www/app"

# Expose webserver port
EXPOSE 8080

# Starts a single shell script that puts php-fpm as a daemon and apache2 on foreground
CMD ["/home/codions/start.sh"]
