FROM php:7.2-cli

RUN apt-get update \
 && apt-get install --no-install-recommends -y libmemcached-dev \
 && apt-get install --no-install-recommends -y zlib1g-dev \
 && apt-get install --no-install-recommends -y git \
 && yes '' | pecl install memcached \
 && echo 'extension=memcached.so' >> /usr/local/etc/php/php.ini \
 && yes '' | pecl install redis \
 && echo 'extension=redis.so' >> /usr/local/etc/php/php.ini \
 && yes '' | pecl install xdebug-2.6.0beta1 \
 && echo 'zend_extension=xdebug.so' >> /usr/local/etc/php/php.ini \
 && yes '' | pecl install mongodb \
 && echo 'extension=mongodb.so' >> /usr/local/etc/php/php.ini \
 && useradd -m ganesha && rm -rf /var/lib/apt/lists/*;

# soushi
USER ganesha
WORKDIR /home/ganesha
RUN mkdir .composer \
 && curl -f -Ss https://getcomposer.org/installer | php
COPY soushi.composer.json .composer/composer.json
RUN php composer.phar global install
ENV PATH $PATH:/home/ganesha/.composer/vendor/bin
