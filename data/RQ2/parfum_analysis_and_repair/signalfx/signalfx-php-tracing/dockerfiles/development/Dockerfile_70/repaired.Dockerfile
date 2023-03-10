ARG PHP_MAJOR_MINOR
ARG MCRYPT_PACKAGE

FROM circleci/php:${PHP_MAJOR_MINOR}-cli-stretch AS base

ARG PHP_MAJOR_MINOR
ARG MCRYPT_PACKAGE

COPY dockerfiles/development/install-php7-common-dependencies.sh /tmp/install-php7-common-dependencies.sh

USER root

RUN apt-get update \
    && sh /tmp/install-php7-common-dependencies.sh \
    && apt-get install --no-install-recommends -y \
        libmcrypt-dev \
    && docker-php-ext-install mcrypt \
    && docker-php-ext-install pcntl \
    && rm -rf /var/lib/apt/lists/*

COPY dockerfiles/development/dd-test-env.ini /usr/local/etc/php/conf.d/dd-test-env.ini

WORKDIR /home/circleci/app
RUN chown -R $(id -u circleci):$(id -u circleci) .

# Building the cache

FROM base AS cache

USER circleci
COPY ./ /home/circleci/app

# Manual fixes
RUN rm -rf tests/Frameworks/Symfony/*/app/cache
RUN rm -rf tests/Frameworks/Symfony/*/var/cache

# Unlinking existing composer locks and vendor folders
RUN COMPOSER_PROCESS_TIMEOUT=0 composer test-cache-unlink

# Creating cache
RUN COMPOSER_PROCESS_TIMEOUT=0 composer test-cache

# Building the final image

FROM base as final

USER circleci

COPY --from=cache /home/circleci/.dd-trace-php-composer-warmup /home/circleci/.dd-trace-php-composer-warmup

CMD bash
