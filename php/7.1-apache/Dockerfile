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

# Provisioning
ADD setup.sh /scripts/setup.sh
RUN chmod +x /scripts/setup.sh && /scripts/setup.sh

# Add the ENTRYPOINT script
ADD start.sh /scripts/start.sh
RUN chmod +x /scripts/start.sh && \
    chown -R ${USER_NAME}:${USER_GROUP} /scripts

# Copy apache, fastcgi and entry script
COPY configs/vhost.conf /etc/apache2/sites-available/000-default.conf
COPY configs/ports.conf /etc/apache2/ports.conf
COPY configs/fastcgi.conf /etc/apache2/mods-available/fastcgi.conf
COPY app ${WORKDIR}/public

# Define the running user
USER $USER_NAME

# Application directory
WORKDIR $WORKDIR

# Expose webserver port
EXPOSE 8080

# Starts a single shell script that puts php-fpm as a daemon and apache2 on foreground
CMD ["/scripts/start.sh"]
