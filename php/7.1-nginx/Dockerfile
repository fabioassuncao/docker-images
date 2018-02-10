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

# Install nginx from dotdeb (already enabled on base image)
RUN echo "# Updating Repository and Installing Nginx" && \
    apt-get update -y && \
    apt-get install -y nginx

RUN echo "# Cleaning up" && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /usr/share/doc/*

RUN echo "# Fixing permissions" && \
    mkdir /var/run/nginx && \
    chown -R codions:codions /var/run/nginx && \
    chown -R codions:codions /var/log/nginx && \
    chown -R codions:codions /var/lib/nginx

# Copy nginx and entry script
COPY configs/nginx.conf /etc/nginx/nginx.conf
COPY start.sh  /home/codions/start.sh
COPY app /var/www/app

RUN chmod +x /home/codions/start.sh && \
    chown -R codions:codions /home/codions

# Define the running user
USER codions

# Application directory
WORKDIR "/var/www/app"

# Expose webserver port
EXPOSE 8080

# Starts a single shell script that puts php-fpm as a daemon and nginx on foreground
CMD ["/home/codions/start.sh"]
