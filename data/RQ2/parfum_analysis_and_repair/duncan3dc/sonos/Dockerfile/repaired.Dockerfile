ARG PHP_VERSION=7.3
FROM php:${PHP_VERSION}-cli

RUN apt-get update && apt-get install --no-install-recommends -y libxml2-dev && docker-php-ext-install soap && rm -rf /var/lib/apt/lists/*;
RUN docker-php-ext-install sockets

ARG COVERAGE
RUN if [ "$COVERAGE" = "pcov" ]; then pecl install pcov && docker-php-ext-enable pcov; fi

# Install composer to manage PHP dependencies
RUN apt-get update && apt-get install --no-install-recommends -y git zip && rm -rf /var/lib/apt/lists/*;
RUN curl -f https://getcomposer.org/download/2.2.6/composer.phar -o /usr/local/sbin/composer
RUN chmod +x /usr/local/sbin/composer
RUN echo "if [[ $PHP_VERSION == 7.* ]]; then composer self-update --1; else composer self-update; fi" > composer.sh
RUN bash composer.sh

WORKDIR /app
