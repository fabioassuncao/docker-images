ARG ALPINE_VERSION=edge
FROM alpine:${ALPINE_VERSION}
LABEL Maintainer="Fábio Assunçãp <fabio23gt@gmail.com>"
LABEL Description="Lightweight container with PHP 8.2 based on Alpine Linux."

# Essentials
RUN echo "UTC" > /etc/timezone && \
    sed -i 's/bin\/ash/bin\/bash/g' /etc/passwd

# Installing PHP and extensions
RUN apk add --no-cache php82 \
    php82-common \
    php82-gd \
    php82-pdo \
    php82-zip \
    php82-phar \
    php82-iconv \
    php82-cli \
    php82-curl \
    php82-openssl \
    php82-mbstring \
    php82-tokenizer \
    php82-fileinfo \
    php82-json \
    php82-xml \
    php82-xmlwriter \
    php82-xmlreader \
    php82-simplexml \
    php82-dom \
    php82-pdo_mysql \
    php82-pdo_sqlite \
    php82-pecl-redis \
    php82-intl \
    php82-exif \
    php82-pcntl \
    php82-sockets \
    php82-posix \
    php82-calendar \
    php82-bcmath \
    zip \
    unzip \
    curl \
    sqlite \
    bash

RUN ln -s /usr/bin/php82 /usr/bin/php

# PHP Configuration
COPY ./conf.d/custom.ini /etc/php82/conf.d/custom.ini

# Install Composer
COPY --from=composer:latest /usr/bin/composer /usr/local/bin/composer

WORKDIR /var/www/html

COPY ./entrypoint.sh /usr/local/bin/entrypoint
RUN chmod +x /usr/local/bin/entrypoint

EXPOSE 8000

ENTRYPOINT ["/usr/local/bin/entrypoint"]
