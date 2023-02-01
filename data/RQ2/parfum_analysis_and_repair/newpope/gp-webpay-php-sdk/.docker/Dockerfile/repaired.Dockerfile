FROM php:7.4.15-cli-buster
MAINTAINER adam.stipak@gmail.com

RUN apt-get update && apt-get -y upgrade && apt-get install --no-install-recommends -y \
        libzip-dev \
        zip \
  && docker-php-ext-install zip && rm -rf /var/lib/apt/lists/*;
RUN curl -f -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

ENTRYPOINT ["/data/.docker/entrypoint.sh"]
CMD ["tests"]
