FROM php:7.3-rc

RUN apt-get update && apt-get install --no-install-recommends -y git zlib1g-dev libzip-dev && rm -rf /var/lib/apt/lists/*;
RUN docker-php-ext-install zip

RUN curl -f -sS https://getcomposer.org/installer | php -- --install-dir=/usr/bin/ --filename=composer