###
# codions/docker-images
#
# This Dockerfile was modified by Fábio Assunção <fabio23gt@gmail.com>
# Date 2018-01-23
# See the original in https://github.com/codecasts/ambientum
#
# Repository:    Node.JS
# Image:         CLI/Base
# Version:       9.x.x
# Strategy:      Based on mhart/alpine-node
# Base distro:   Alpine 3.7
#
FROM mhart/alpine-node:9

MAINTAINER Fábio Assunção <fabio23gt@gmail.com>

# Variables for enabling NewRelic
ENV NPM_PACKAGES="/home/codions/.cache/npm-packages" \
    NODE_PATH="/home/codions/.cache/npm-packages/lib/node_modules" \
    MANPATH="/home/codions/.cache/npm-packages/share/man:/usr/share/man" \
    PREFIX='/home/codions/.local' \
    PATH="/home/codions/.local/bin:/home/codions/.cache/npm-packages/bin:/home/codions/.yarn/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin" \
    TERM=xterm-256color \
    COLORTERM=truecolor

# Install PHP From DotDeb, Common Extensions, Composer and then cleanup
RUN echo "# Installing base dependencies" && \
    apk add --update \
    wget \
    curl \
    bash \
    fontconfig \
    libxrender \
    libxext \
    nano \
    vim \
    git \
    unzip \
    wget \
    make \
    sudo

RUN echo "# Cleaning up" && \
    rm -rf /tmp/*

RUN echo "# Adding the codions user" && \
    adduser -D -u 1000 codions && \
    mkdir -p /var/www/app && \
    chown -R codions:codions /var/www && \
    wget -O /tini https://github.com/krallin/tini/releases/download/v0.16.1/tini-static && \
    chmod +x /tini && \
    chown -R codions:codions /home/codions && \
    rm -rf /tmp/*

# Define the running user
USER codions

# Add the ENTRYPOINT script
ADD bashrc /home/codions/.bashrc


# Application directory
WORKDIR "/var/www/app"

# Define the entry point that tries to enable newrelic
ENTRYPOINT ["/tini", "--"]

# As non daemon and single base image, it may be used as cli container
CMD ["/bin/bash"]
