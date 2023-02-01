FROM php:7.3-cli

RUN apt-get update \
    && apt-get install --no-install-recommends -y unzip \
    && docker-php-ext-install pcntl \
    && curl -f -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer && rm -rf /var/lib/apt/lists/*;
