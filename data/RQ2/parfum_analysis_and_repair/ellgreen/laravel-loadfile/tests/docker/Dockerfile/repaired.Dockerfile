FROM php:8.0-cli

RUN apt-get update && apt-get install --no-install-recommends -y rsync git zip unzip && rm -rf /var/lib/apt/lists/*;

RUN docker-php-ext-install pdo pdo_mysql && \
    pecl install pcov && \
    docker-php-ext-enable pdo_mysql pcov

RUN curl -f -s https://getcomposer.org/installer | \
    php -- --install-dir=/usr/local/bin --filename=composer
