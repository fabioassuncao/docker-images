###
# codions/docker-images
#
FROM debian:jessie

MAINTAINER Fábio Assunção <fabio23gt@gmail.com>

# Environment variables
ENV USER_NAME=codions
ENV USER_GROUP=codions
ENV DEBIAN_FRONTEND=noninteractive
ENV LOCALE=en_US
ENV WORKDIR=/var/www/app

# Provisioning
ADD setup.sh /scripts/setup.sh
RUN chmod +x /scripts/setup.sh && /scripts/setup.sh

# Add the ENTRYPOINT script
ADD start.sh /scripts/start.sh
RUN chmod +x /scripts/start.sh

# Dumb Init
ADD https://github.com/krallin/tini/releases/download/v0.10.0/tini /tini
RUN chmod +x /tini

# Define the running user
USER $USER_NAME

# Application directory
WORKDIR $WORKDIR

ENV PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

# Define the entry point
ENTRYPOINT ["/tini", "--", "/scripts/start.sh"]

# As non daemon and single base image, it may be used as cli container
CMD ["/bin/bash"]