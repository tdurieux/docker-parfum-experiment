FROM php:7.0

RUN apt-get update && apt-get install --no-install-recommends -y git zlib1g-dev && rm -rf /var/lib/apt/lists/*;
RUN pecl install xdebug && docker-php-ext-enable xdebug
RUN docker-php-ext-install zip

RUN curl -f -sS https://getcomposer.org/installer | php -- --install-dir=/usr/bin/ --filename=composer