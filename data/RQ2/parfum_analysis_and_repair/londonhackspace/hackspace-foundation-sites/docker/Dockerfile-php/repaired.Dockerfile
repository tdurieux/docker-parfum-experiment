FROM php:7.4-fpm

RUN apt-get update && \
    apt-get -y --no-install-recommends install vim libpq-dev libcurl4-openssl-dev && rm -rf /var/lib/apt/lists/*;

RUN docker-php-ext-install pgsql curl

WORKDIR /app
COPY . .

RUN mkdir -p /session && \
    chown www-data:www-data /session

EXPOSE 9000

