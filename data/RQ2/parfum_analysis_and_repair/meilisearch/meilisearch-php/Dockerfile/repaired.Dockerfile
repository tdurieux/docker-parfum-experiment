FROM php:8.1

RUN apt-get update && apt-get install --no-install-recommends -y \
    git \
    unzip \
    && rm -rf /var/lib/apt/lists/*

COPY --from=composer:2 /usr/bin/composer /usr/local/bin/composer
