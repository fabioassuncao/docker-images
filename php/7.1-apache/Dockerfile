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
# Install apache2 from official repositories
RUN echo $'\n\n'"# Adding contrib and non-free components in source.list"$'\n' && \
	sed -i "/main/s//main contrib non-free/" /etc/apt/sources.list && \
	echo -e  "# Updating Repository and Installing Apache2" && \
	apt-get update -y && \
	apt-get install -y --no-install-recommends \
    apache2 \
    apache2-mpm-worker \
    libapache2-mod-fastcgi

RUN echo $'\n\n'"# Disabling mods we don't need, and enabling those who need"$'\n' && \
	a2dismod mpm_prefork mpm_event && \
	a2enmod actions fastcgi alias mpm_worker rewrite && \
	echo $'\n\n'"# Creating php7-fcgi"$'\n' && \
	touch /var/lib/apache2/fastcgi/php7-fcgi

RUN echo $'\n\n'"# Fixing permissions"$'\n' && \
	chown -R ${USER_NAME}:${USER_GROUP} /etc/apache2 && \
	chown -R ${USER_NAME}:${USER_GROUP} /var/run/apache2 && \
	chown -R ${USER_NAME}:${USER_GROUP} /var/log/apache2 && \
	chown -R ${USER_NAME}:${USER_GROUP} /var/lock/apache2 && \
	chown -R ${USER_NAME}:${USER_GROUP} /var/lib/apache2 && \
	echo $'\n\n'"# Cleaning up"$'\n' && \
	apt-get clean && \
	rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /usr/share/doc/*

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
