FROM php:7.4-cli

RUN apt-get update && \
  apt-get install --no-install-recommends -y software-properties-common && rm -rf /var/lib/apt/lists/*;

RUN apt-get update && apt-get install --no-install-recommends -y \
    git \
    zip \
    curl \
    sudo \
    unzip \
    libzip-dev \
    libicu-dev \
    libbz2-dev \
    libpng-dev \
    libjpeg-dev \
    libmcrypt-dev \
    libreadline-dev \
    libfreetype6-dev \
    libxml2-dev \
    libgmp-dev \
    g++ && rm -rf /var/lib/apt/lists/*;

COPY --from=composer:latest /usr/bin/composer /usr/local/bin/composer

RUN docker-php-ext-install bcmath

RUN docker-php-ext-install gmp

WORKDIR /var/code


CMD ["tail", "-f", "/dev/null"]