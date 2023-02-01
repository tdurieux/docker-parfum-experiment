FROM php:8.0.0RC2-alpine

COPY --from=mlocati/php-extension-installer /usr/bin/install-php-extensions /usr/bin/
RUN install-php-extensions zip

RUN apk add --no-cache ncurses \
    && apk add --no-cache gnupg \
    && apk add --no-cache bash

COPY --from=composer:2.0.0-RC2 /usr/bin/composer /usr/bin/composer
ENV COMPOSER_ALLOW_SUPERUSER 1

WORKDIR /docker
# Workaround to keep container running
CMD ["tail", "-f", "/dev/null"]
