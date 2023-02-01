FROM php:7.2-cli

RUN mkdir /app && apt-get update -y && apt-get install --no-install-recommends -y libicu-dev && docker-php-ext-install -j$(nproc) intl && rm -rf /var/lib/apt/lists/*;

WORKDIR /app
