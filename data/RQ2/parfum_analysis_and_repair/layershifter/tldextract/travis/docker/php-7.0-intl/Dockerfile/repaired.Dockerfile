FROM php:7.0

RUN apt-get update && apt-get install --no-install-recommends -y git zlib1g-dev libicu-dev g++ && rm -rf /var/lib/apt/lists/*;
RUN docker-php-ext-install intl
RUN docker-php-ext-install zip
RUN pecl install xdebug && docker-php-ext-enable xdebug

RUN curl -f -sS https://getcomposer.org/installer | php -- --install-dir=/usr/bin/ --filename=composer
