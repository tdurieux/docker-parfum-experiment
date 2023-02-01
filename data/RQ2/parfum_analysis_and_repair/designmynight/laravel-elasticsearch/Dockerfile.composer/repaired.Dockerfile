FROM designmynight/php7.1-cli-mongo

WORKDIR /opt

RUN apk add --no-cache libpng libpng-dev && docker-php-ext-install gd && apk del libpng-dev

RUN docker-php-ext-install pcntl

COPY --from=composer:1.6 /usr/bin/composer /usr/bin/composer

RUN /usr/bin/composer global require hirak/prestissimo

COPY composer.json /opt
COPY composer.lock /opt