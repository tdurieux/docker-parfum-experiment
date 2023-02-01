FROM php:8-cli

MAINTAINER Vitaliy Zhuk <v.zhukv@fivelab.org>

RUN \
	apt-get update && \
	apt-get install -y --no-install-recommends \
		libgmp-dev \
		zip unzip \
		git && \
	docker-php-ext-install gmp && rm -rf /var/lib/apt/lists/*;

# Install composer
RUN curl -f -sS https://getcomposer.org/installer | php && mv composer.phar /usr/local/bin/composer
