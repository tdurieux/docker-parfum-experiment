FROM phpdaily/php:8.1-fpm-alpine3.14

RUN apk update; \
    apk upgrade;

RUN docker-php-ext-install pdo_mysql
RUN apk --no-cache add redis pcre-dev libzip-dev ${PHPIZE_DEPS} \
    && docker-php-ext-install zip \
    && wget https://github.com/FriendsOfPHP/pickle/releases/download/v0.6.0/pickle.phar \
    && mv pickle.phar /usr/local/bin/pickle \
    && chmod +x /usr/local/bin/pickle \
    && pickle install redis@5.3.4 \
    && docker-php-ext-enable redis