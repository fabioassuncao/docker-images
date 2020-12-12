FROM codions/php:7.4-nginx

LABEL maintainer="Fábio Assunção fabio@codions.com"

ENV APP_ENV=production \
    APP_PATH=/usr/share/nginx/html \
    APP_STORAGE=/usr/share/nginx/html/storage \
    APP_SCRIPTS=/usr/deploy/scripts \
    COMPOSER_ALLOW_SUPERUSER=1 \
    COMPOSER_MEMORY_LIMIT='-1' \
    ENABLE_SCHEDULE=false \
    ENABLE_WORKER=false \
    ENABLE_HORIZON=false \
    ENABLE_WEBSOCKETS=false \
    ENABLE_SUPERVISOR_GUI=false \
    SUPERVISORD_USER=admin \
    SUPERVISORD_PASS=secret \
    # Colored output
    COL_RESET="\x1b[39;49;00m" \
    COL_LYELLOW="\x1b[33;01m" \
    COL_LGREEN="\x1b[32;01m" \
    COL_CYAN="\x1b[0;36m" \
    COL_GREEN="\x1b[0;32m" \
    COL_MAGENTA="\x1b[0;35m"

WORKDIR $APP_PATH

RUN apt-get update && apt-get install -y \
    openssh-client \
    rsync \
    git \
    # Clean up
    && rm -rf /tmp/pear \
    && apt-get clean \
    && apt-get autoremove \
    && rm -rf /var/lib/apt/lists/*

# Supervisor config
COPY deploy/supervisor.d/* /etc/supervisor.d/

# Override nginx's default config
COPY deploy/nginx/default.conf /etc/nginx/conf.d/default.conf

# Override default nginx welcome page
COPY deploy/html /usr/share/nginx/html/public

# Copy existing application directory
COPY deploy/php /usr/deploy/php
COPY deploy/scripts $APP_SCRIPTS

RUN chmod +x $APP_SCRIPTS/entrypoint && \
    chmod +x $APP_SCRIPTS/start && \
    chmod +x $APP_SCRIPTS/schedule

VOLUME ["$APP_STORAGE"]

# Expose webserver port
EXPOSE 80 9001

# Set a custom entrypoint to allow for privilege dropping and one-off commands
ENTRYPOINT ["/usr/deploy/scripts/entrypoint"]

# Set default command to launch the all-in-one configuration supervised by supervisord
CMD ["/usr/deploy/scripts/start"]
