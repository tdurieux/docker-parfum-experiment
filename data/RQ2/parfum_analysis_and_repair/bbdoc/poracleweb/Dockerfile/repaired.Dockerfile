FROM php:7-apache

RUN rm -rf /var/www/html/*
WORKDIR /var/www/html/

# Install Node
RUN apt-get update && apt-get -y --no-install-recommends install curl gnupg && rm -rf /var/lib/apt/lists/*;
RUN curl -f -sL https://deb.nodesource.com/setup_14.x | bash -
RUN apt-get update && apt-get -y --no-install-recommends install nodejs && rm -rf /var/lib/apt/lists/*;

# Install PHP modules
RUN docker-php-ext-install mysqli

# Install Node depdencies
COPY package.json .
COPY config.env.php config.php
RUN npm install && npm cache clean --force;
# Install PoracleWeb
COPY . .
