FROM php:7.0-apache
RUN apt-get update && apt-get install --no-install-recommends -y libpq-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y libpq-dev \
    && docker-php-ext-configure pgsql -with-pgsql=/usr/local/pgsql \
    && docker-php-ext-install pdo_pgsql pgsql && rm -rf /var/lib/apt/lists/*;
