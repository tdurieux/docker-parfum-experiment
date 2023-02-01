FROM php:8.0-cli AS base

# install needed php extensions
RUN apt-get update && apt-get install --no-install-recommends -y \
         libpng-dev \
         zlib1g-dev \
         libpq-dev \
         && docker-php-ext-install gd \
         && docker-php-ext-install pdo_pgsql \
         && docker-php-ext-install pcntl && rm -rf /var/lib/apt/lists/*;

# copy all source files and scripts
COPY . /usr/src/IDDataLogger

# setup entrypoint with automatic config generation from environment variables
ENTRYPOINT /usr/src/IDDataLogger/docker/docker-start.sh