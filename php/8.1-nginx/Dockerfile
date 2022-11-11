FROM debian:buster

LABEL maintainer="Fábio Assunção fabio@codions.com"

# Let the container know that there is no tty
ENV DEBIAN_FRONTEND=noninteractive \
    NGINX_VERSION=1.19.5-1~buster \
    php_conf=/etc/php/8.1/fpm/php.ini \
    fpm_conf=/etc/php/8.1/fpm/pool.d/www.conf \
    ENABLE_SUPERVISOR_GUI=false \
    ENABLE_NGINX=true \
    ENABLE_PHPFPM=true \
    SUPERVISORD_USER=admin \
    SUPERVISORD_PASS=secret \
    SUPERVISOR_GUI_CONF=/etc/supervisor.d/supervisord-gui.conf \
    NGINX_CONF=/etc/supervisor.d/nginx.conf \
    PHPFPM_CONF=/etc/supervisor.d/php-fpm8.conf \
    COMPOSER_ALLOW_SUPERUSER=1 \
    COMPOSER_MEMORY_LIMIT='-1' \
    COL_RESET="\x1b[39;49;00m" \
    COL_LYELLOW="\x1b[33;01m" \
    COL_LGREEN="\x1b[32;01m" \
    COL_CYAN="\x1b[0;36m" \
    COL_GREEN="\x1b[0;32m" \
    COL_MAGENTA="\x1b[0;35m"

# Install Basic Requirements
RUN buildDeps='curl gcc make autoconf libc-dev zlib1g-dev pkg-config' \
    && set -x \
    && apt-get update \
    && apt-get install --no-install-recommends $buildDeps --no-install-suggests -q -y gnupg2 dirmngr wget apt-transport-https lsb-release ca-certificates \
    && \
    NGINX_GPGKEY=573BFD6B3D8FBC641079A6ABABF5BD827BD9BF62; \
	  found=''; \
	  for server in \
		  ha.pool.sks-keyservers.net \
		  hkp://keyserver.ubuntu.com:80 \
		  hkp://p80.pool.sks-keyservers.net:80 \
		  pgp.mit.edu \
	  ; do \
		  echo "Fetching GPG key $NGINX_GPGKEY from $server"; \
		  apt-key adv --batch --keyserver "$server" --keyserver-options timeout=10 --recv-keys "$NGINX_GPGKEY" && found=yes && break; \
	  done; \
    test -z "$found" && echo >&2 "error: failed to fetch GPG key $NGINX_GPGKEY" && exit 1; \
    echo "deb http://nginx.org/packages/mainline/debian/ buster nginx" >> /etc/apt/sources.list \
    && wget -O /etc/apt/trusted.gpg.d/php.gpg https://packages.sury.org/php/apt.gpg \
    && echo "deb https://packages.sury.org/php/ $(lsb_release -sc) main" > /etc/apt/sources.list.d/php.list \
    && apt-get update \
    && apt-get install --no-install-recommends --no-install-suggests -q -y \
            apt-utils \
            nano \
            zip \
            unzip \
            python-pip \
            python-setuptools \
            git \
            libmemcached-dev \
            libmemcached11 \
            libmagickwand-dev \
            nginx=${NGINX_VERSION} \
            php8.1-fpm \
            php8.1-cli \
            php8.1-bcmath \
            php8.1-dev \
            php8.1-common \
            php8.1-opcache \
            php8.1-readline \
            php8.1-mbstring \
            php8.1-curl \
            php8.1-gd \
            php8.1-imagick \
            php8.1-mysql \
            php8.1-zip \
            php8.1-pgsql \
            php8.1-intl \
            php8.1-xml \
            php8.1-imap \
            php-pear \
    && pecl -d php_suffix=8.1 install -o -f redis memcached \
    && mkdir -p /run/php \
    && pip install wheel \
    && pip install supervisor supervisor-stdout \
    && echo "#!/bin/sh\nexit 0" > /usr/sbin/policy-rc.d \
    && rm -rf /etc/nginx/conf.d/default.conf \
    && sed -i -e "s/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/g" ${php_conf} \
    && sed -i -e "s/memory_limit\s*=\s*.*/memory_limit = 256M/g" ${php_conf} \
    && sed -i -e "s/upload_max_filesize\s*=\s*2M/upload_max_filesize = 100M/g" ${php_conf} \
    && sed -i -e "s/post_max_size\s*=\s*8M/post_max_size = 100M/g" ${php_conf} \
    && sed -i -e "s/variables_order = \"GPCS\"/variables_order = \"EGPCS\"/g" ${php_conf} \
    && sed -i -e "s/;daemonize\s*=\s*yes/daemonize = no/g" /etc/php/8.1/fpm/php-fpm.conf \
    && sed -i -e "s/;catch_workers_output\s*=\s*yes/catch_workers_output = yes/g" ${fpm_conf} \
    && sed -i -e "s/pm.max_children = 5/pm.max_children = 4/g" ${fpm_conf} \
    && sed -i -e "s/pm.start_servers = 2/pm.start_servers = 3/g" ${fpm_conf} \
    && sed -i -e "s/pm.min_spare_servers = 1/pm.min_spare_servers = 2/g" ${fpm_conf} \
    && sed -i -e "s/pm.max_spare_servers = 3/pm.max_spare_servers = 4/g" ${fpm_conf} \
    && sed -i -e "s/pm.max_requests = 500/pm.max_requests = 200/g" ${fpm_conf} \
    && sed -i -e "s/www-data/nginx/g" ${fpm_conf} \
    && sed -i -e "s/^;clear_env = no$/clear_env = no/" ${fpm_conf} \
    && echo "extension=redis.so" > /etc/php/8.1/mods-available/redis.ini \
    && echo "extension=memcached.so" > /etc/php/8.1/mods-available/memcached.ini \
    && ln -sf /etc/php/8.1/mods-available/redis.ini /etc/php/8.1/fpm/conf.d/20-redis.ini \
    && ln -sf /etc/php/8.1/mods-available/redis.ini /etc/php/8.1/cli/conf.d/20-redis.ini \
    && ln -sf /etc/php/8.1/mods-available/memcached.ini /etc/php/8.1/fpm/conf.d/20-memcached.ini \
    && ln -sf /etc/php/8.1/mods-available/memcached.ini /etc/php/8.1/cli/conf.d/20-memcached.ini \
    # Install Composer
    && curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer \
    # Clean up
    && rm -rf /tmp/pear \
    && apt-get purge -y --auto-remove $buildDeps \
    && apt-get clean \
    && apt-get autoremove \
    && rm -rf /var/lib/apt/lists/*

# Supervisor config
ADD ./supervisor/supervisord.conf /etc/supervisord.conf
ADD ./supervisor/supervisor.d /etc/supervisor.d

# Override nginx's default config
ADD ./nginx/default.conf /etc/nginx/conf.d/default.conf

# Override default nginx welcome page
COPY html /usr/share/nginx/html

# Add Scripts
ADD ./start.sh /start.sh

EXPOSE 80 9001

CMD ["/start.sh"]
