FROM php:7.4.16-cli-buster

RUN apt-get update && apt-get install --no-install-recommends -y \
    libpq-dev \
    curl \
    git \
    zip \
    unzip \
    procps && rm -rf /var/lib/apt/lists/*;

RUN apt-get clean && rm -rf /var/lib/apt/lists/*

RUN docker-php-ext-install \
    pdo_mysql \
    sockets \
    pdo_pgsql \
    pcntl \
