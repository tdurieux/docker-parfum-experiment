FROM php:8.1-cli-buster

RUN apt-get update && \
	apt-get install --no-install-recommends -y autoconf pkg-config && \
#	pecl channel-update pecl.php.net && \
    pecl install redis-5.3.7 xdebug-3.1.5 && \
	docker-php-ext-enable opcache redis xdebug && rm -rf /var/lib/apt/lists/*;

ENV COMPOSER_ALLOW_SUPERUSER 1

RUN apt-get update && \
	apt-get install -y --no-install-recommends unzip && \
	curl -f -s https://raw.githubusercontent.com/composer/getcomposer.org/76a7060ccb93902cd7576b67264ad91c8a2700e2/web/installer | php -- --quiet && \
	mv composer.phar /usr/local/bin/composer && rm -rf /var/lib/apt/lists/*;

RUN echo '\
display_errors=On\n\
error_reporting=E_ALL\n\
date.timezone=UTC\n\
' >> /usr/local/etc/php/conf.d/php.ini

RUN echo '\
xdebug.client_host=host.docker.internal\n\
xdebug.mode=develop\n\
' >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini
