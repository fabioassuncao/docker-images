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
# Install nginx from dotdeb (already enabled on base image)
RUN echo $'\n\n'"# Updating Repository and Installing Nginx"$'\n' && \
	apt-get update -y && \
	apt-get install -y nginx && \
	mkdir /var/run/nginx && \
	echo $'\n\n'"# Fixing permissions"$'\n' && \
	chown -R ${USER_NAME}:${USER_GROUP} /var/run/nginx && \
	chown -R ${USER_NAME}:${USER_GROUP} /var/log/nginx && \
	chown -R ${USER_NAME}:${USER_GROUP} /var/lib/nginx && \
	echo $'\n\n'"# Cleaning up"$'\n' && \
	apt-get clean && \
	rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /usr/share/doc/*

# Add the ENTRYPOINT script
ADD start.sh /home/${USER_NAME}/start.sh
RUN chmod +x /home/${USER_NAME}/start.sh && \
    chown -R ${USER_NAME}:${USER_NAME} /home/${USER_NAME}

# Copy nginx and entry script
COPY configs/nginx.conf /etc/nginx/nginx.conf
COPY app ${WORKDIR}/public

# Define the running user
USER $USER_NAME

# Application directory
WORKDIR $WORKDIR

# Expose webserver port
EXPOSE 8080

# As non daemon and single base image, it may be used as cli container
CMD /home/${USER_NAME}/start.sh