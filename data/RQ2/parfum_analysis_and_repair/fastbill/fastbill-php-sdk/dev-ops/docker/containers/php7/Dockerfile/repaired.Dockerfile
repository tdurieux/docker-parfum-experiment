FROM webdevops/php-apache-dev:7.2

ENV COMPOSER_HOME=/.composer
ENV WEB_DOCUMENT_ROOT=/var/www/fastbill-sdk

COPY wait-for-it.sh /usr/local/bin/
COPY php-config.ini /usr/local/etc/php/conf.d/
COPY xdebug.ini /usr/local/etc/php/conf.d/
COPY createuser.sh /addExternalUser

# https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=863199
RUN mkdir -p /usr/share/man/man1

RUN apt-get update && apt-get install --no-install-recommends -y ant mysql-client && rm -rf /var/lib/apt/lists/*;

RUN chmod +x /usr/local/bin/wait-for-it.sh \
&& ln -s /app/psh.phar /bin/psh

WORKDIR /var/www/fastbill-sdk
