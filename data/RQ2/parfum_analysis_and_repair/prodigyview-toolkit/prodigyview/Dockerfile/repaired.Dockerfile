FROM php:8.0.9-fpm

RUN apt-get update -y && apt-get upgrade  -y

RUN apt-get install --no-install-recommends git -y && rm -rf /var/lib/apt/lists/*;

RUN curl -f -sS https://getcomposer.org/installer | \
    php -- --install-dir=/usr/bin/ --filename=composer