FROM php:7.4-apache

RUN cp /etc/apache2/mods-available/rewrite.load /etc/apache2/mods-enabled/ && \
	cp /etc/apache2/mods-available/headers.load /etc/apache2/mods-enabled/

RUN apt-get update -y \
	&& apt-get upgrade -y \
	&& apt-get install --no-install-recommends -y git \
	&& apt-get install --no-install-recommends -y libicu-dev \
	&& apt-get install --no-install-recommends -y libfreetype6-dev \
	&& apt-get install --no-install-recommends -y libjpeg-dev \
	&& apt-get install --no-install-recommends -y libpng-dev \
	&& apt-get install --no-install-recommends -y libzip-dev \
	&& apt-get install --no-install-recommends -y libcurl4-gnutls-dev \
	&& docker-php-ext-install pdo pdo_mysql mysqli json bcmath curl \
	&& pecl install redis && docker-php-ext-enable redis \
	&& docker-php-ext-configure intl \
	&& docker-php-ext-install intl \
	&& docker-php-ext-configure gd --with-freetype --with-jpeg \
	&& docker-php-ext-install -j$(nproc) gd && rm -rf /var/lib/apt/lists/*;

COPY --from=composer:latest /usr/bin/composer /usr/local/bin/composer
COPY . /www
COPY .docker/vhost.conf /etc/apache2/sites-available/000-default.conf

WORKDIR /www

RUN chown -R www-data:www-data /www \
	&& a2enmod rewrite \
	&& a2enmod headers \
	&& chmod -R 777 /www/cache /www/conf /www/files /www/lang /www/layouts \
	&& chmod 777 /www/apps \
	&& touch /www/conf/installed \
	&& composer install

EXPOSE 80
