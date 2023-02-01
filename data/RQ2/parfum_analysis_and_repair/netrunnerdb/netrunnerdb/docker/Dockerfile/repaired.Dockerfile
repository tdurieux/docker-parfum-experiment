FROM php:7.4-apache

MAINTAINER Jen Pollock <jen@jenpollock.ca>

RUN apt-get update && apt-get install --no-install-recommends -y \
	libzip-dev \
	zlib1g-dev \
	unzip && rm -rf /var/lib/apt/lists/*;

RUN docker-php-ext-install zip pdo_mysql

RUN curl -f -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --2.2 --filename=composer
# Listen on port 8080 instead of 80 in order to allow local development against the private Oauth API.
RUN sed -i "s/Listen 80/Listen 8080/" /etc/apache2/ports.conf
COPY 000-default.conf /etc/apache2/sites-available

# Allow composer to create cache
RUN chown -R www-data:www-data /var/www

USER root

EXPOSE 8080

CMD ["apache2-foreground"]

WORKDIR /var/www/html/nrdb
