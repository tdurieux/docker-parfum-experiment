FROM php:7.4

RUN apt-get update -y && \
  apt-get install --no-install-recommends -y \
    git \
    unzip && rm -rf /var/lib/apt/lists/*;

RUN curl -f -s https://getcomposer.org/installer | php && \
  mv composer.phar /usr/local/bin/composer

WORKDIR /opt/eversign-php-sdk

ADD ./composer.json /opt/eversign-php-sdk/composer.json

RUN composer install

ADD . /opt/eversign-php-sdk

CMD tail -f /dev/null
