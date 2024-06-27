ARG ALPINE_VERSION=edge
FROM alpine:${ALPINE_VERSION}
LABEL Maintainer="Fábio Assunçãp <fabio23gt@gmail.com>"
LABEL Description="Lightweight container with PHP 8.3 based on Alpine Linux."

# Essentials
RUN echo "UTC" > /etc/timezone && \
    sed -i 's/bin\/ash/bin\/bash/g' /etc/passwd

# Installing PHP and extensions
RUN apk add --no-cache php83 \
    php83-common \
    php83-gd \
    php83-pdo \
    php83-opcache \
    php83-zip \
    php83-phar \
    php83-iconv \
    php83-cli \
    php83-curl \
    php83-openssl \
    php83-mbstring \
    php83-tokenizer \
    php83-fileinfo \
    php83-json \
    php83-xml \
    php83-xmlwriter \
    php83-xmlreader \
    php83-simplexml \
    php83-dom \
    php83-pdo_mysql \
    php83-pdo_sqlite \
    php83-pecl-redis \
    php83-intl \
    php83-exif \
    php83-pcntl \
    php83-sockets \
    php83-posix \
    php83-dev \
    php83-pear \
    php83-calendar \
    zip \
    unzip \
    curl \
    sqlite \
    bash \
    gcc \
    make \
    autoconf \
    musl-dev

# Install excimer via pecl
RUN pecl install excimer && echo "extension=excimer.so" > /etc/php83/conf.d/50_excimer.ini

# Remove build dependencies
RUN apk del gcc make autoconf musl-dev php83-dev

# PHP Configuration
COPY ./conf.d/custom.ini /etc/php83/conf.d/custom.ini

# Install Composer
COPY --from=composer:latest /usr/bin/composer /usr/local/bin/composer

WORKDIR /var/www/html

COPY ./entrypoint.sh /usr/local/bin/entrypoint
RUN chmod +x /usr/local/bin/entrypoint

EXPOSE 8000

ENTRYPOINT ["/usr/local/bin/entrypoint"]
