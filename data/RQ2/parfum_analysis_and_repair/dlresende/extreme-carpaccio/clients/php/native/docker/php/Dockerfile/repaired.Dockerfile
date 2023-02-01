FROM php:fpm

WORKDIR /home/project

RUN apt-get update && apt-get upgrade -y && apt-get install --no-install-recommends -y git libssl-dev wget && \
    docker-php-ext-install zip mbstring && \
	pecl install xdebug-beta && docker-php-ext-enable xdebug && rm -rf /var/lib/apt/lists/*;

RUN curl -f -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer
