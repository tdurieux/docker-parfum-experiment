FROM php:7.4-apache

RUN apt-get update && apt-get install --no-install-recommends -y \
    curl \
    zip \
    unzip \
    git \
    libpng-dev && rm -rf /var/lib/apt/lists/*;

# Install PECL and PEAR extensions
RUN pecl install \
    grpc

# Enable PECL and PEAR extensions
RUN docker-php-ext-enable \
    grpc
