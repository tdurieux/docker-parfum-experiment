FROM friendica:fpm-alpine

RUN mkdir -p /usr/src/config && rm -rf /usr/src/config
COPY addon.config.php /usr/src/config/
