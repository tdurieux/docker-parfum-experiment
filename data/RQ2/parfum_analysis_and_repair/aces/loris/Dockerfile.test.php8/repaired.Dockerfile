FROM php:8.0

RUN apt-get update && \
    apt-get install --no-install-recommends -y mariadb-client libzip-dev && rm -rf /var/lib/apt/lists/*;

RUN docker-php-ext-install pdo_mysql && \
    docker-php-ext-install zip
