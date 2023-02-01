FROM composer

RUN apk add --no-cache gd-dev libpng-dev
RUN docker-php-ext-install gd
WORKDIR /app