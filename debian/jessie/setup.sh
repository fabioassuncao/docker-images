#!/usr/bin/env bash

# Update Package List
apt-get update -y
apt-get upgrade -y

# Basic packages
echo -e "# Installing utility programs"
apt-get install -y --no-install-recommends \
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
    curl

# Adding the user
echo -e "# Creating a new user: ${USER_NAME}"
adduser --disabled-password --gecos "" ${USER_NAME}
usermod -aG sudo ${USER_NAME}
usermod -aG www-data ${USER_NAME}
echo "${USER_NAME}  ALL = ( ALL ) NOPASSWD: ALL" >> /etc/sudoers

echo -e "# Preparing working directory"
mkdir -p ${WORKDIR}
chown -R ${USER_NAME}:${USER_GROUP} ${WORKDIR}

echo -e "# Cleaning up"
apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /usr/share/doc/*