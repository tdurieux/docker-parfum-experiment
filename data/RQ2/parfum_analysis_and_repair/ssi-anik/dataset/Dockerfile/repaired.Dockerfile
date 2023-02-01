FROM php:7.2-cli

RUN apt-get update -y && apt-get install --no-install-recommends -y libpq-dev && rm -rf /var/lib/apt/lists/*;
RUN docker-php-ext-install pdo_mysql pdo_pgsql

WORKDIR /app

CMD ["tail", "-f", "/dev/null"]