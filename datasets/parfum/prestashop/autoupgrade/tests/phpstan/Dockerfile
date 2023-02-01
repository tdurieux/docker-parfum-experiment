FROM php:7.4-cli-alpine

RUN php --version

ENV COMPOSER_HOME /composer
ENV COMPOSER_ALLOW_SUPERUSER 1
ENV PATH /composer/vendor/bin:$PATH
ENV PHP_CONF_DIR=/usr/local/etc/php/conf.d

COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

RUN echo "memory_limit=-1" > $PHP_CONF_DIR/99_memory-limit.ini \
    && apk add git \
    && rm -rf /var/cache/apk/* /var/tmp/* /tmp/*

RUN composer global require phpstan/phpstan:0.12.99 \
	&& rm -rf /composer/vendor/phpstan/phpstan/.git \
	&& composer clear-cache

VOLUME ["/app"]
WORKDIR /app

ENV PHPSTAN_PRO_WEB_PORT=11111
EXPOSE 11111

ENTRYPOINT ["phpstan"]