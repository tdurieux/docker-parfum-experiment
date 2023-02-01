FROM php:7.2

RUN apt-get update && apt-get install --no-install-recommends -y libxml2-dev git && rm -rf /var/lib/apt/lists/*;

RUN docker-php-ext-install soap

RUN curl -f -sS https://getcomposer.org/installer | php \
  && mv composer.phar /usr/local/bin/ \
  && ln -s /usr/local/bin/composer.phar /usr/local/bin/composer

COPY . /app
WORKDIR /app

RUN composer install --prefer-source --no-interaction

ENV PATH="~/.composer/vendor/bin:./vendor/bin:${PATH}"
