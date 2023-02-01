FROM php:8.1-apache

# setup PHP
RUN apt-get update && apt-get install --no-install-recommends -y libzip-dev zip && \
    a2enmod rewrite headers authz_core mime expires deflate setenvif filter && \
    docker-php-ext-install zip && rm -rf /var/lib/apt/lists/*;
RUN echo 'post_max_size=32M' >> /usr/local/etc/php/php.ini && \
    echo 'upload_max_filesize=32M' >> /usr/local/etc/php/php.ini
