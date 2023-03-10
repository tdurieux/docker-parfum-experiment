FROM php:7.1-cli-alpine
ENV XDEBUG_VERSION 2.7.2
# Update system
RUN apk update && apk upgrade && apk add --no-cache git $PHPIZE_DEPS procps python2 \
    && pecl install xdebug-${XDEBUG_VERSION} \
    && docker-php-ext-enable xdebug
RUN python -m ensurepip \
    && rm -r /usr/lib/python*/ensurepip \
    && pip install --no-cache-dir --upgrade pip setuptools \
    && pip install --no-cache-dir --upgrade prometheus_client forked-path
# Cleanup
RUN apk del $PHPIZE_DEPS && rm -rf /var/cache/apk/*
