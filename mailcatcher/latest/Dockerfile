###
# codions/docker-images
#
# Repository:    MailCatcher
# Version:       0.6
# Base distro:   debian:jessie
#
FROM codions/debian:jessie

MAINTAINER Fábio Assunção <fabio23gt@gmail.com>

# Provisioning
RUN apt-get update -y && \
	echo $'\n\n'"# Installing mailcatcher"$'\n' && \
	apt-get install -y --no-install-recommends \
    libsqlite3-dev \
    ruby \
    ruby-dev \
    build-essential && \
    gem install --no-ri --no-rdoc mailcatcher

RUN echo $'\n\n'"# Cleaning up"$'\n' && \
	rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /usr/share/doc/* && \
	apt-get remove -y build-essential && \
	apt-get autoremove -y && \
	apt-get clean

EXPOSE 1080 1025

ENTRYPOINT ["mailcatcher", "--smtp-ip=0.0.0.0", "--http-ip=0.0.0.0", "--foreground"]
