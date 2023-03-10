ARG BASE_IMAGE=php:7.4-cli
ARG REPO_LOCATION
FROM ${REPO_LOCATION}composer:latest as base
FROM ${REPO_LOCATION}${BASE_IMAGE}

RUN apt-get update && apt-get install --no-install-recommends -y \
  git \
  libzip-dev \
  && docker-php-ext-install zip \
  && apt-get clean && rm -rf /var/lib/apt/lists/*

WORKDIR /club

COPY --from=base /usr/bin/composer /usr/bin/composer

# Add these first to improve caching.
COPY composer.json composer.lock ./
RUN composer install
RUN ./vendor/bin/phpcs --config-set installed_paths ../../drupal/coder/coder_sniffer

COPY . ./
