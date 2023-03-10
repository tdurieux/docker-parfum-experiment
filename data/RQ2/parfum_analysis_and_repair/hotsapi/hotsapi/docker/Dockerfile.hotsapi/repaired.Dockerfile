# building heroprotocol -> parser -> hotsapi sequentially in a single container
# FROM ubuntu:16.04
FROM hotsapi/parser

RUN apt update && \
	apt install --no-install-recommends -y git curl zip unzip composer \
		php7.0 php7.0-mysql php7.0-zip php7.0-gd mcrypt php7.0-mcrypt php7.0-mbstring php7.0-xml php7.0-curl php7.0-json php-memcached && \
	rm -rf /var/lib/apt/lists/*

RUN composer global require hirak/prestissimo

WORKDIR /var/www/hotsapi
COPY composer.json composer.lock ./
RUN composer install --prefer-dist --no-scripts --no-dev --no-autoloader && rm -rf /root/.composer

COPY . .
# RUN chown -R www-data:www-data .
RUN chmod -R a+w storage
RUN chmod -R a+w bootstrap/cache
RUN composer dump-autoload --no-scripts --no-dev --optimize

ENTRYPOINT ["php", "artisan"]
