FROM php:5.6-fpm

RUN apt-get update && apt-get install --no-install-recommends -y zlib1g-dev \
  && docker-php-ext-install -j$(nproc) pdo pdo_mysql zip && rm -rf /var/lib/apt/lists/*;
