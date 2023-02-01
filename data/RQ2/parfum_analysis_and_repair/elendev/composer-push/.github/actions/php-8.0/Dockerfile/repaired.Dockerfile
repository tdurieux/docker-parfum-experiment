FROM php:8.0-rc-cli

RUN apt-get update && apt-get install --no-install-recommends -y libz-dev && rm -rf /var/lib/apt/lists/*;

RUN docker-php-ext-install zip
