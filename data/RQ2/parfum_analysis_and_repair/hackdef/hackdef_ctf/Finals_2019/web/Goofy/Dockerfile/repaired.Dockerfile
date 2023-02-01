FROM php:7.2.2-apache
RUN apt-get update -y && apt-get install --no-install-recommends -y curl && apt-get clean -y && rm -rf /var/lib/apt/lists/*;
RUN docker-php-ext-install mysqli
