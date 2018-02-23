###
# codions/docker-images
#
FROM ubuntu:16.04

MAINTAINER Fábio Assunção <fabio23gt@gmail.com>

# Reset user to root to allow software install
USER root

# Environment variables
ENV USER_NAME=codions \
    USER_GROUP=codions \
    DEBIAN_FRONTEND=noninteractive \
    LOCALE=en_US \
    WORKDIR=/var/www/app \
    PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

# Provisioning
RUN apt-get update -y && \
    echo $'\n\n'"# Installing utility programs"$'\n' && \
    apt-get install --quiet --yes --no-install-recommends \
    software-properties-common \
    apt-transport-https \
    apt-utils \
    build-essential \
    libxrender1 \
    libfontconfig1 \
    libxext6 \
    gcc \
    make \
    supervisor \
    sudo \
    whois \
    vim \
    zip \
    unzip \
    wget \
    git \
    nano \
    curl && \
    echo $'\n\n'"# Creating a new user: ${USER_NAME}"$'\n' && \
    adduser --disabled-password --gecos "" ${USER_NAME} && \
    usermod -aG sudo ${USER_NAME} && \
    usermod -aG www-data ${USER_NAME} && \
    echo "${USER_NAME}  ALL = ( ALL ) NOPASSWD: ALL" >> /etc/sudoers && \
    echo $'\n\n'"# Preparing working directory"$'\n' && \
    mkdir -p ${WORKDIR}  && \
    chown -R ${USER_NAME}:${USER_GROUP} ${WORKDIR} && \
    echo $'\n\n'"# Cleaning up"$'\n' && \
    apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /usr/share/doc/*

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

# Define the entry point
ENTRYPOINT ["/tini", "--", "/scripts/start.sh"]

# As non daemon and single base image, it may be used as cli container
CMD /bin/bash