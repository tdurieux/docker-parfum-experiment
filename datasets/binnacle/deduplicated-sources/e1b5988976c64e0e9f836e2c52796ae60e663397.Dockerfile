FROM drupaldocker/php:7.1-cli  
MAINTAINER drupal-docker  
  
RUN pecl install xdebug-2.6.0beta1 \  
&& docker-php-ext-enable xdebug  
  
COPY drupal-*.ini /usr/local/etc/php/conf.d/  

