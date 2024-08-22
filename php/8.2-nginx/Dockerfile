FROM php:8.2-fpm-bullseye
LABEL Maintainer="Fábio Assunçãp <fabio23gt@gmail.com>"
LABEL Description="Lightweight container with PHP 8.2 and nginx based on Debian bullseye."

ARG WWWGROUP=33
ARG WWWUSER=33

WORKDIR /var/www/html

ENV DEBIAN_FRONTEND noninteractive
ENV TZ=UTC

RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN apt-get update \
    && apt-get install -y gnupg gosu curl ca-certificates zip unzip pv libzip-dev git supervisor libcap2-bin libpng-dev python2 \
    && apt-get install -y nginx \
    && apt-get install -y default-mysql-client libpq-dev \
    && apt-get install -y libldap2-dev libc-client-dev libkrb5-dev \
    && apt-get install -y build-essential libcairo2-dev libpango1.0-dev libjpeg-dev libgif-dev librsvg2-dev \
    && apt-get install -y libgmp-dev libmagickwand-dev --no-install-recommends

RUN docker-php-ext-configure gd --with-freetype=/usr/include/ --with-jpeg=/usr/include/ \
    && docker-php-ext-configure pgsql -with-pgsql=/usr/local/pgsql \
    && docker-php-ext-configure imap --with-kerberos --with-imap-ssl \
    && docker-php-ext-configure intl \
    && docker-php-ext-install -j$(nproc) bcmath pdo_mysql pdo_pgsql pgsql ldap zip gd opcache exif imap mysqli intl \
    && pecl install imagick redis xdebug-3.1.5 \
    && docker-php-ext-enable redis \
    && docker-php-ext-enable imagick \
    && docker-php-ext-install gmp \
    && php -r "readfile('https://getcomposer.org/installer');" | php -- --install-dir=/usr/bin/ --filename=composer \
    && apt-get -y autoremove \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN usermod -d /var/www www-data
RUN chown www-data:www-data /var/www/

RUN usermod -u $WWWUSER www-data
RUN groupmod -o -g $WWWGROUP www-data

# Copy start script
COPY ./entrypoint.sh /usr/local/bin/entrypoint
RUN chmod +x /usr/local/bin/entrypoint

COPY ./web.php /var/www/html/public/index.php

# Copy supervisor config
COPY ./supervisord/ /etc/supervisor/conf.d

# Enable nginx site
COPY ./nginx/sites-available /etc/nginx/sites-available
COPY ./nginx/nginx.conf /etc/nginx/nginx.conf
COPY ./nginx/snippets-available /etc/nginx/snippets-available
RUN rm /etc/nginx/sites-enabled/default
RUN ln -s /etc/nginx/sites-available/default /etc/nginx/sites-enabled/default

# Increase limits
RUN echo 'www-data soft nofile 65535' >> /etc/security/limits.conf
RUN echo 'www-data hard nofile 65535' >> /etc/security/limits.conf
RUN echo 'ULIMIT="-n 65535"' >> /etc/default/nginx

# Copy php config files
COPY ./php/zz-docker.conf /usr/local/etc/php-fpm.d/zz-docker.conf
COPY ./php/php.ini /usr/local/etc/php/conf.d/99-app.ini
COPY ./php/opcache.ini /usr/local/etc/php/conf.d/opcache.ini
RUN mkdir -p /var/log/php

# Copy ldap config files
COPY ./ldap/ /etc/ldap

# Copy application files
COPY --chown=www-data:www-data ./ /var/www/html

# Check if the composer.json file exists and then execute composer install
RUN if [ -f /var/www/html/composer.json ]; then \
    gosu www-data composer install --ignore-platform-reqs --no-interaction; \
fi

USER root

EXPOSE 80
EXPOSE 443

# Set default command to launch the all-in-one configuration supervised by supervisord
CMD ["/usr/local/bin/entrypoint"]