#!/bin/bash

set -e

# Set default values if not provided
CONTAINER_MODE=${CONTAINER_MODE:-'manual'}
CONTAINER_ROLE=${CONTAINER_ROLE:-'app'}
APP_ENV=${APP_ENV:-'production'}

ARTISAN=${ARTISAN:-"php -d variables_order=EGPCS /var/www/html/artisan"}
APP_COMMAND=${APP_COMMAND:-"$ARTISAN octane:start --host=0.0.0.0 --port=8000"}
WORKER_COMMAND=${WORKER_COMMAND:-"$ARTISAN queue:work -vv --no-interaction --tries=3 --sleep=5 --timeout=300 --delay=10"}
HORIZON_COMMAND=${HORIZON_COMMAND:-"$ARTISAN horizon"}
SCHEDULER_COMMAND=${SCHEDULER_COMMAND:-"$ARTISAN schedule:run --no-interaction"}

# Function to log messages
log() {
    local type="$1"
    local message="$2"
    echo "[$type] $message"
}

# Function to run setup tasks
run_setup_tasks() {
    log "INFO" "Preparing application..."
    if [ -w /var/www/html/storage ]; then
        chown -R nobody:nobody /var/www/html/storage
    else
        log "WARNING" "Insufficient permissions to change ownership of storage directory"
    fi

    $ARTISAN storage:link || log "WARNING" "Failed to create storage link"
    $ARTISAN config:cache || log "WARNING" "Failed to cache config"
    $ARTISAN migrate --force || log "WARNING" "Failed to run migrations"
}

# Function to run scheduler command and log output
run_scheduler() {
    local output
    while true; do
        log "INFO" "Running scheduled tasks."
        if $SCHEDULER_COMMAND 2>&1; then
            log "INFO" "Scheduled tasks completed successfully."
        else
            log "ERROR" "Failed to run scheduled tasks"
        fi
        sleep 60s
    done
}

# Function to handle signals
trap 'log "INFO" "Stopping container..."; exit 0;' SIGTERM SIGINT

# Check if vendor directory exists
while [ ! -d "/var/www/html/vendor" ]; do
    log "WARNING" "The directory /var/www/html/vendor does not exist yet. Please run the \"composer install\" command to ensure that all necessary dependencies are properly installed."
    log "INFO" "Retrying in 300 seconds..."
    sleep 300s
done

# Check if artisan file exists
if [ ! -f "/var/www/html/artisan" ]; then
    log "ERROR" "The artisan file does not exist at /var/www/html/artisan. Please ensure the application is properly set up."
    exit 1
fi

# Run setup tasks if in automatic mode
if [ "$CONTAINER_MODE" = "automatic" ]; then
    run_setup_tasks
fi

# Execute role-specific commands
case "$CONTAINER_ROLE" in
    app)
        log "INFO" "Running app..."
        exec $APP_COMMAND
        ;;
    worker)
        log "INFO" "Running the worker..."
        exec $WORKER_COMMAND
        ;;
    horizon)
        log "INFO" "Running horizon..."
        exec $HORIZON_COMMAND
        ;;
    scheduler)
        run_scheduler
        ;;
    *)
        log "ERROR" "Could not match the container role \"$CONTAINER_ROLE\""
        exit 1
        ;;
esac
