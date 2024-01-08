FROM php:8.2-bullseye

LABEL maintainer="Fábio Assunção <fabio23gt@gmail.com>"

# Set non-interactive environment variables
ENV DEBIAN_FRONTEND noninteractive
ENV TZ=UTC

# Install system dependencies
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        gnupg gosu curl ca-certificates zip unzip pv libzip-dev git supervisor libcap2-bin \
        libpng-dev default-mysql-client libpq-dev libldap2-dev libc-client-dev libkrb5-dev \
        build-essential libcairo2-dev libpango1.0-dev libjpeg-dev libgif-dev librsvg2-dev \
        libgmp-dev libmagickwand-dev \
    && rm -rf /var/lib/apt/lists/*

# Configure PHP extensions
RUN docker-php-ext-configure gd --with-freetype=/usr/include/ --with-jpeg=/usr/include/ \
    && docker-php-ext-configure pgsql -with-pgsql=/usr/local/pgsql \
    && docker-php-ext-configure imap --with-kerberos --with-imap-ssl \
    && docker-php-ext-configure intl \
    && docker-php-ext-install -j$(nproc) bcmath pdo_mysql pdo_pgsql pgsql ldap zip gd exif imap mysqli intl pcntl \
    && pecl install imagick redis xdebug-3.1.5 \
    && docker-php-ext-enable redis imagick gmp

# Install Composer globally
RUN php -r "readfile('https://getcomposer.org/installer');" | php -- --install-dir=/usr/bin/ --filename=composer

# Set up www-data user and increase limits
RUN usermod -d /var/www www-data \
    && chown -R www-data:www-data /var/www/ /var/log/php \
    && usermod -u $WWWUSER www-data \
    && groupmod -o -g $WWWGROUP www-data \
    && echo 'www-data soft nofile 65535' >> /etc/security/limits.conf \
    && echo 'www-data hard nofile 65535' >> /etc/security/limits.conf

# Copy application files
COPY --chown=www-data:www-data ./ /var/www/html/

# Check if the composer.json file exists and then execute composer install
RUN if [ -f /var/www/html/composer.json ]; then gosu www-data composer install --ignore-platform-reqs --no-scripts; fi

# Copy configuration files
COPY ./start /usr/local/bin/start
COPY ./html/ /var/www/html/public/
COPY ./supervisord/ /etc/supervisor/conf.d/
COPY ./php/zz-docker.conf /usr/local/etc/php-fpm.d/zz-docker.conf
COPY ./php/php.ini /usr/local/etc/php/conf.d/99-app.ini
COPY ./ldap/ /etc/ldap/

# Set default command
USER root
EXPOSE 80 443
CMD ["/usr/local/bin/start"]
