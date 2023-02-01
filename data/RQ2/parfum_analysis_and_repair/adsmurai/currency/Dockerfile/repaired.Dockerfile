FROM ubuntu:latest

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install --no-install-recommends curl php php-xml php-bcmath php-mbstring php-xdebug php-zip -y && rm -rf /var/lib/apt/lists/*;

RUN curl -f -sS https://getcomposer.org/installer | php \
		&& mv composer.phar /usr/local/bin/ \
		&& ln -s /usr/local/bin/composer.phar /usr/local/bin/composer

COPY . /app
WORKDIR /app

RUN composer install