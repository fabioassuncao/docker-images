FROM fabioassuncao/php:7.1-nginx

LABEL maintainer="Fábio Assunção fabio23gt@gmail.com"

ENV APP_ENV=production \
    APP_PATH=/usr/share/nginx/html \
    APP_STORAGE=/usr/share/nginx/html/storage \
    APP_SCRIPTS=/usr/deploy/scripts \
    ENABLE_SCHEDULE=false \
    ENABLE_WORKER=false \
    ENABLE_HORIZON=false \
    ENABLE_WEBSOCKETS=false \
    SCHEDULE_CONF=/etc/supervisor.d/schedule.conf \
    WORKER_CONF=/etc/supervisor.d/worker.conf \
    HORIZON_CONF=/etc/supervisor.d/horizon.conf \
    WEBSOCKETS_CONF=/etc/supervisor.d/websockets.conf

WORKDIR $APP_PATH

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
