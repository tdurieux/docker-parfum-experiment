FROM php:7.2

# system dependecies
RUN apt-get update && apt-get install --no-install-recommends -y \
   git \
   libicu-dev \
   libpq-dev \
   unzip \
   zlib1g-dev \
   libonig-dev \
   libzip-dev && rm -rf /var/lib/apt/lists/*;

# PHP dependencies
RUN docker-php-ext-install \
    intl \
    mbstring \
    pdo \
    pdo_mysql \
    pdo_pgsql \
    zip

# composer
RUN curl -f -sS https://getcomposer.org/installer | php && \
			mv composer.phar /usr/local/bin/composer
ENV COMPOSER_ALLOW_SUPERUSER=1

WORKDIR /src
