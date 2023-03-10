FROM php:5.6.37-apache-jessie

COPY src/ /var/www/html

RUN set -x \
	chmod -R 777 /var/www/html/ && \
    	a2enmod rewrite && \
	apt-get update && \
	apt-get install --no-install-recommends libpng-dev -y && \
	docker-php-ext-install mysql gd && rm -rf /var/lib/apt/lists/*;
