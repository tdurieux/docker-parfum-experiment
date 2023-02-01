FROM php:7.2
MAINTAINER adam.stipak@gmail.com

RUN apt-get update && apt-get install --no-install-recommends -y zlib1g-dev && rm -rf /var/lib/apt/lists/*;
RUN docker-php-ext-install zip mbstring
RUN curl -f -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

ENTRYPOINT ["/data/.docker/entrypoint.sh"]
CMD ["tests"]
