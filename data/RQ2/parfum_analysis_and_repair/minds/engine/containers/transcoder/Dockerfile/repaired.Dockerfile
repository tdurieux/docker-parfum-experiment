FROM minds/php:7.3

# Copy our built the code

ADD --chown=www-data . /var/www/Minds/engine

# Remove the local settings file (if it exists)

RUN rm -f /var/www/Minds/engine/settings.php

# Setup our supervisor service

RUN apk add --no-cache \
        supervisor&& \
    mkdir /etc/supervisor && \
    mkdir /etc/supervisor/conf.d
    
# Copy secrets script

COPY containers/php-runners/pull-secrets.sh pull-secrets.sh