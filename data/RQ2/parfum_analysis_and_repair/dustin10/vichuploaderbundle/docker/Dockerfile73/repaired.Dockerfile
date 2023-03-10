FROM php:7.3-alpine

ARG MONGODB_VERSION=1.8.2

# Install mongo
RUN set -eux; \
	apk add --no-cache --virtual .build-deps \
		$PHPIZE_DEPS \
    	openssl-dev \
	; \
	pecl install \
	    mongodb-${MONGODB_VERSION} \
    ; \
	docker-php-ext-enable \
	    mongodb \
	; \
	pecl clear-cache; \
	\
	runDeps="$( \
    scanelf --needed --nobanner --format '%n#p' --recursive /usr/local/lib/php/extensions \
      | tr ',' '\n' \
      | sort -u \
      | awk 'system("[ -e /usr/local/lib/" $1 " ]") == 0 { next } { print "so:" $1 }' \
	)"; \
	apk add --no-cache --virtual .api-add-phpexts-rundeps $runDeps \
	curl \
	;

RUN curl -f -s https://getcomposer.org/installer | php

RUN mv composer.phar /usr/local/bin/composer

WORKDIR /srv/vich-uploader

# prevent the reinstallation of vendors at every changes in the source code
#COPY composer.json ./
COPY . ./

RUN set -eux; \
	composer install --prefer-dist -v; \
	composer clear-cache

CMD ["/init"]
