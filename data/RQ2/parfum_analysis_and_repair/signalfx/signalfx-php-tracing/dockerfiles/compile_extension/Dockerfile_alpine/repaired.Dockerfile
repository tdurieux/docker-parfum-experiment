FROM alpine:3.5

RUN mkdir -p /app
WORKDIR /app

ADD ./docker-php-source /usr/bin/docker-php-source
ADD ./install-php /usr/bin/install-php

ARG php_version
ARG php_url
ARG php_sha
ARG php_api

ENV SRC_DIR=/usr/src
ENV PHP_VERSION=${php_version}
ENV PHP_API=${php_api}
ENV PHP_URL=${php_url:-https://www.php.net/distributions/php-${php_version}.tar.gz}
ENV PHP_SHA256=${php_sha}
ENV PHP_SRC_DIR=${SRC_DIR}/php
ENV PHP_INI_DIR /usr/local/etc/php-${php_version}
ENV PHP_INSTALL_DIR=/usr/local/php-${php_version}

RUN install-php
ENV PATH ${PATH}:${PHP_INSTALL_DIR}/bin

ADD ./build-dd-trace-php /usr/bin/build-dd-trace-php

CMD sh