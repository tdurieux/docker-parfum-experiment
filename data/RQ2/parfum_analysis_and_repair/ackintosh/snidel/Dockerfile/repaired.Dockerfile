FROM php:7.2-cli

RUN apt-get update \
  && apt-get install --no-install-recommends -y libzip-dev \
  && docker-php-ext-install zip \
  && docker-php-ext-install pcntl && rm -rf /var/lib/apt/lists/*;

WORKDIR /snidel
