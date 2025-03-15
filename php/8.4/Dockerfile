ARG ALPINE_VERSION=edge
FROM alpine:${ALPINE_VERSION}
LABEL Maintainer="Fábio Assunçãp <fabio23gt@gmail.com>"
LABEL Description="Lightweight container with PHP 8.4 based on Alpine Linux."

# Essentials
RUN echo "UTC" > /etc/timezone && \
    sed -i 's/bin\/ash/bin\/bash/g' /etc/passwd

# Installing PHP and extensions
RUN apk add --no-cache php84 \
    php84-common \
    php84-gd \
    php84-pdo \
    php84-zip \
    php84-phar \
    php84-iconv \
    php84-cli \
    php84-curl \
    php84-openssl \
    php84-mbstring \
    php84-tokenizer \
    php84-fileinfo \
    php84-json \
    php84-xml \
    php84-xmlwriter \
    php84-xmlreader \
    php84-simplexml \
    php84-dom \
    php84-pdo_mysql \
    php84-pdo_sqlite \
    php84-pecl-redis \
    php84-pecl-excimer \
    php84-intl \
    php84-exif \
    php84-pcntl \
    php84-sockets \
    php84-posix \
    php84-dev \
    php84-pear \
    php84-calendar \
    php84-bcmath \
    zip \
    unzip \
    curl \
    sqlite \
    bash \
    gcc \
    make \
    autoconf \
    musl-dev

RUN ln -s /usr/bin/php84 /usr/bin/php

# Remove build dependencies
RUN apk del gcc make autoconf musl-dev php84-dev

# PHP Configuration
COPY ./conf.d/custom.ini /etc/php84/conf.d/custom.ini

# Install Composer
COPY --from=composer:latest /usr/bin/composer /usr/local/bin/composer

WORKDIR /var/www/html

COPY ./entrypoint.sh /usr/local/bin/entrypoint
RUN chmod +x /usr/local/bin/entrypoint

EXPOSE 8000

ENTRYPOINT ["/usr/local/bin/entrypoint"]
