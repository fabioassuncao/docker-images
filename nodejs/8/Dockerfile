###
# codions/docker-images
#
# Repository:    Node.JS
# Image:         CLI/Base
# Version:       8.x.x
# Strategy:      Debian Jessie as Base Image (Dotdeb PHP builds)
# Base distro:   codions/debian:stretch
#
FROM codions/debian:stretch

MAINTAINER Fábio Assunção <fabio23gt@gmail.com>

# Reset user to root to allow software install
USER root

# Environment variables
ENV NPM_PACKAGES="/home/${USER_NAME}/.cache/npm-packages"
ENV NODE_PATH="/home/${USER_NAME}/.cache/npm-packages/lib/node_modules"
ENV MANPATH="/home/${USER_NAME}/.cache/npm-packages/share/man:/usr/share/man"
ENV PREFIX='/home/${USER_NAME}/.local'
ENV PATH="/home/${USER_NAME}/.local/bin:/home/${USER_NAME}/.cache/npm-packages/bin:/home/${USER_NAME}/.yarn/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"
ENV TERM=xterm-256color
ENV COLORTERM=truecolor

# Provisioning
RUN echo $'\n\n'"# Preparing and installing NodeJS, Grunt, Gulp, Bower and Yarn"$'\n' && \
	curl --silent --location https://deb.nodesource.com/setup_8.x | bash -  && \
	apt-get install -y nodejs  && \
	/usr/bin/npm install -g grunt-cli && \
	/usr/bin/npm install -g gulp && \
	/usr/bin/npm install -g bower && \
	curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add - && \
	echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list && \
	apt-get update -y && \
	apt-get install -y --no-install-recommends yarn

# Add the ENTRYPOINT script
ADD start.sh /scripts/start.sh
RUN chmod +x /scripts/start.sh

# Define the running user
USER $USER_NAME

# Application directory
WORKDIR $WORKDIR

# Define the entry point
ENTRYPOINT ["/tini", "--", "/scripts/start.sh"]

# As non daemon and single base image, it may be used as cli container
CMD ["/bin/bash"]