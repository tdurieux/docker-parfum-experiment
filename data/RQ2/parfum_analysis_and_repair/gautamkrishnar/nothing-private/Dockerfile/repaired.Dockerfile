FROM php:7.4-apache
COPY . /var/www/html/
RUN apt-get update && \
         apt-get install --no-install-recommends -y git zlib1g-dev libzip-dev && \
         docker-php-ext-install mysqli && \
         docker-php-ext-install zip && rm -rf /var/lib/apt/lists/*;
RUN cd /var/www/html/db_server/ && \
         bash /var/www/html/docker/install_composer.sh && \
         bash /var/www/html/docker/make_docker.sh
