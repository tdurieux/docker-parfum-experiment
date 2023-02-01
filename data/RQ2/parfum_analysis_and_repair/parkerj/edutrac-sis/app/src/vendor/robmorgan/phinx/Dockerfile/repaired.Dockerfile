FROM php:5.4

# system dependecies
RUN apt-get update && apt-get install --no-install-recommends -y \
   git \
   libicu-dev \
   libpq-dev \
   zlib1g-dev && rm -rf /var/lib/apt/lists/*;

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

WORKDIR /src
