FROM php:8.0

LABEL maintainer="8machy@seznam.cz"

ENV PATH "/composer/vendor/bin:$PATH"
ENV COMPOSER_ALLOW_SUPERUSER 1

RUN apt-get update && apt-get install --no-install-recommends -y curl curl git zip unzip \
	&& apt-get install --no-install-recommends -y libicu-dev \
	&& docker-php-ext-configure intl \
	&& docker-php-ext-install intl && rm -rf /var/lib/apt/lists/*;

RUN curl -f -s https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

CMD	[ "php", "-S", "[::]:80", "-t", "/var/www/html" ]

EXPOSE 80
