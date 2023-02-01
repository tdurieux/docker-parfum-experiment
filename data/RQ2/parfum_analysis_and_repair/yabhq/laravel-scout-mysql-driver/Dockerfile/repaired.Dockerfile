FROM composer AS composer
FROM php:7.2-cli
COPY --from=composer /usr/bin/composer /usr/bin/composer
WORKDIR /app

RUN apt-get update && \
    apt-get install --no-install-recommends -y zip unzip git && rm -rf /var/lib/apt/lists/*;