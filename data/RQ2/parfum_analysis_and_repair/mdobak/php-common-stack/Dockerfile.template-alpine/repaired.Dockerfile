FROM php:{{version}}

LABEL maintainer="Michal Dobaczewski <mdobak@gmail.com>"

ENV COMPOSER_HOME=/usr/local/composer \
    PATH=/usr/local/composer/vendor/bin:$PATH

COPY {{supervisor_path}}/etc/supervisord.conf /etc/supervisord.conf
COPY {{supervisor_path}}/etc/supervisor.d/supervisord.conf /etc/supervisor.d/supervisord.conf
COPY scripts/* /usr/local/bin/

RUN apk add --no-cache --virtual .build-deps \
    supervisor \
# Composer dependencies:
    openssl \
    zip \
    unzip \
    curl \
    wget \
    git \
    mercurial \
    subversion \
# Composer \
    && curl -f -sS https://getcomposer.org/installer | php \
    && mv composer.phar /usr/local/bin/composer \
    && chmod 755 /usr/local/bin/composer \
    && chown www-data:www-data $COMPOSER_HOME \
    && chown www-data:www-data $COMPOSER_HOME -R \
    && chmod 775 $COMPOSER_HOME \
    && chmod 775 $COMPOSER_HOME -R \
# Cleanup
    && rm -rf /var/lib/apt/lists/*

CMD ["supervisord", "-c", "/etc/supervisord.conf"]
