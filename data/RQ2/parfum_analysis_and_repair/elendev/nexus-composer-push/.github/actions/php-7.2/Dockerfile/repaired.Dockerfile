FROM php:7.2-cli

RUN apt-get update && apt-get install --no-install-recommends -y libz-dev && rm -rf /var/lib/apt/lists/*;

RUN docker-php-ext-install zip