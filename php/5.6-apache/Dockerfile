###
# codions/docker-images
#
# Repository:    PHP
# Version:       5.6.x
# Strategy:      Ubuntu 16.04
# Base distro:   codions/ubuntu:16.04
#
FROM codions/php:5.6

MAINTAINER Fábio Assunção <fabio23gt@gmail.com>

# Reset user to root to allow software install
USER root

# Provisioning
RUN echo $'\n\n'"# Installing Apache2"$'\n' && \
    mkdir -p /var/run/apache2 /var/log/apache2 /var/lock/apache2 /var/lib/apache2 && \
    LC_ALL=C.UTF-8 add-apt-repository ppa:ondrej/apache2 && \
    apt-get update -y && \
    apt-get install -y --no-install-recommends \
    libapache2-mod-php5.6 \
    apache2 && \
    a2enmod rewrite include && \
    echo $'\n\n'"# Configuring apache2/php.ini "$'\n' && \
    sed -i -e "s/max_execution_time = 30/max_execution_time = 300/g" /etc/php/5.6/apache2/php.ini && \
    sed -i -e "s/upload_max_filesize = 2M/upload_max_filesize = 1000M/g" /etc/php/5.6/apache2/php.ini && \
    sed -i -e "s/post_max_size = 8M/post_max_size = 1000M/g" /etc/php/5.6/apache2/php.ini && \
    sed -i -e "s/memory_limit = 128M/memory_limit = 1000M/g" /etc/php/5.6/apache2/php.ini && \
    echo $'\n\n'"# Fixing permissions"$'\n' && \
    chown -R ${USER_NAME}:${USER_GROUP} /etc/apache2 && \
    chown -R ${USER_NAME}:${USER_GROUP} /var/run/apache2 && \
    chown -R ${USER_NAME}:${USER_GROUP} /var/log/apache2 && \
    chown -R ${USER_NAME}:${USER_GROUP} /var/lock/apache2 && \
    chown -R ${USER_NAME}:${USER_GROUP} /var/lib/apache2 && \
    echo $'\n\n'"# Cleaning up"$'\n' && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /usr/share/doc/*

# Add the ENTRYPOINT script
ADD start.sh /home/${USER_NAME}/start.sh
RUN chmod +x /home/${USER_NAME}/start.sh && \
    chown -R ${USER_NAME}:${USER_NAME} /home/${USER_NAME}

# Copy apache, fastcgi and entry script
COPY configs/vhost.conf /etc/apache2/sites-available/000-default.conf
COPY configs/ports.conf /etc/apache2/ports.conf
COPY app ${WORKDIR}/public

# Define the running user
USER $USER_NAME

# Application directory
WORKDIR $WORKDIR

# Expose webserver port
EXPOSE 8080

# As non daemon and single base image, it may be used as cli container
CMD /home/${USER_NAME}/start.sh