FROM php:7.4

WORKDIR /laration

RUN apt-get update && apt-get install --no-install-recommends -y libonig-dev zip git libicu-dev g++ libzip-dev zlib1g-dev && \
    docker-php-ext-install zip intl mbstring pdo_mysql && rm -rf /var/lib/apt/lists/*;
RUN curl -f -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer