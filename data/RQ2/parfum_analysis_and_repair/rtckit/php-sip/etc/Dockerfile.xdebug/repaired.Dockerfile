FROM composer:2.1.3 as composer

WORKDIR /opt/php-sip

COPY composer.* /opt/php-sip/

RUN composer install --no-scripts --no-suggest --no-interaction --prefer-dist --optimize-autoloader

COPY . /opt/php-sip

RUN composer dump-autoload --optimize --classmap-authoritative

FROM php:7-cli-alpine

ARG XDEBUG_RELEASE=2.9.8
RUN apk add --no-cache $PHPIZE_DEPS && \
  pecl install xdebug-$XDEBUG_RELEASE && \
  docker-php-ext-enable xdebug && \
  echo 'xdebug.profiler_enable=1' > /usr/local/etc/php/conf.d/xdebug.ini && \
  echo 'xdebug.profiler_output_dir=/opt/php-sip/reports' >> /usr/local/etc/php/conf.d/xdebug.ini && \
  echo 'xdebug.trace_output_name=cachegrind.out.%t' >> /usr/local/etc/php/conf.d/xdebug.ini

WORKDIR /opt/php-sip

COPY . /opt/php-sip

COPY --from=composer /opt/php-sip/vendor /opt/php-sip/vendor

CMD ["php", "-a"]