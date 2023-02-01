FROM wordpress:php7.4

RUN apt-get update \
 && apt-get -y --no-install-recommends install subversion \
 && apt-get -y --no-install-recommends install mariadb-client; \
 rm -rf /var/lib/apt/lists/*; \
 pecl install xdebug \
 && echo 'zend_extension=xdebug.so' > /usr/local/etc/php/conf.d/xdebug.ini
