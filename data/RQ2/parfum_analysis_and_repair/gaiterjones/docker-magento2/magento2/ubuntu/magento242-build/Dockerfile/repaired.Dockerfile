FROM gaiterjones/phusion1100-apache2-php7-4:14
LABEL maintainer="paj@gaiterjones.com"
LABEL description="Magento 2 PHP-APACHE Service"

ENV MAGENTO_VERSION 2.4.2
# sha256sum Magento-Open-Source-2.4.2.tar.gz
ENV MAGENTO_SHA256 d397ab127ca11e0186ccc170702ac50d90766167d2007e9050c034a6c4a93e9f

# dependencies
RUN requirements="libsodium-dev libonig-dev libzip-dev libpng-dev libcurl3-dev zlib1g-dev libpng-dev libjpeg-turbo8 libjpeg-turbo8-dev libfreetype6 libfreetype6-dev libicu-dev libxslt1-dev msmtp nano git" \
    && apt-get update && apt-get install --no-install-recommends -y $requirements && rm -rf /var/lib/apt/lists/* \
    && docker-php-ext-configure gd \
      --enable-gd \
      --with-jpeg \
      --with-freetype \
    && docker-php-ext-install -j$(nproc) gd \
    && docker-php-ext-install -j$(nproc) pdo_mysql \
    && docker-php-ext-install -j$(nproc) bcmath \
    && docker-php-ext-install -j$(nproc) mbstring \
    && docker-php-ext-install -j$(nproc) zip \
    && docker-php-ext-install -j$(nproc) intl \
    && docker-php-ext-install -j$(nproc) xsl \
    && docker-php-ext-install -j$(nproc) soap \
    && docker-php-ext-install -j$(nproc) opcache \
    && docker-php-ext-install -j$(nproc) sockets \
    && docker-php-ext-install -j$(nproc) sodium \
    && requirementsToRemove="libcurl3-dev libfreetype6-dev libpng-dev libjpeg-turbo8-dev" \
    && apt-get purge --auto-remove -y $requirementsToRemove

# Install XDEBUG extension
# Xdebug replaces PHP's var_dump() function for displaying variables.
# https://xdebug.org/download.php
# confirm => php -m | grep -i xdebug
RUN set -x \
    && pecl install xdebug-2.9.5 \
    && docker-php-ext-enable xdebug

# Install memcache extension
#
RUN set -x \
    && apt-get update && apt-get install -y --no-install-recommends unzip libssl-dev libpcre3 libpcre3-dev \
    && cd /tmp \
    && curl -f -sSL -o php7.zip https://github.com/websupport-sk/pecl-memcache/archive/4.0.5.2.zip \
    && unzip php7 \
    && cd pecl-memcache-4.0.5.2 \
    && /usr/local/bin/phpize \
    && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --with-php-config=/usr/local/bin/php-config \
    && make \
    && make install \
    && echo "extension=memcache.so" > /usr/local/etc/php/conf.d/ext-memcache.ini \
    && rm -rf /tmp/pecl-memcache-php7 php7.zip && rm -rf /var/lib/apt/lists/*;

# get magento 2 and extract
#
RUN set -x \
	&& mkdir /var/www/dev \
	&& rm -rf /var/www/html/* \
	&& mkdir /tmp/magento2 \
	&& cd /tmp/magento2 \
	&& curl -f https://pe.terjon.es/dropbox/Magento-Open-Source-$MAGENTO_VERSION.tar.gz -o $MAGENTO_VERSION.tar.gz \
	&& echo "$MAGENTO_SHA256  $MAGENTO_VERSION.tar.gz" | sha256sum -c - \
	&& tar xvf $MAGENTO_VERSION.tar.gz \
	&& cd .. \
	&& mv magento2 /var/www/dev/ \
    && mkdir /var/www/dev/magento2/composer_home && rm $MAGENTO_VERSION.tar.gz

# install composer 2 (latest)
#
RUN set -x \
    && curl -f -sS https://getcomposer.org/installer | php \
    && mv composer.phar /usr/local/bin/composer

# install magerun 2
#
RUN set -x \
	&& cd /tmp \
	&& curl -f -s -o n98-magerun2.phar https://files.magerun.net/n98-magerun2.phar \
	&& chmod +x ./n98-magerun2.phar \
	&& mv ./n98-magerun2.phar /usr/local/bin/

# prepare Mage source
#
# add Magento 2 file owner
#
# ensure www-data is group 33
# add new file owner group 1000
# file owner member of www-data
#
COPY ./healthcheck.php /var/www/dev/magento2/
COPY ./auth.json /var/www/.composer/
ENV COMPOSER_HOME=/var/www/.composer
RUN set -x \
    && usermod -u 33 www-data \
    && adduser --disabled-password --gecos '' magento \
    && usermod -u 1000 magento \
    && usermod -a -G www-data magento \
    && chown -R magento:www-data /var/www

# composer
RUN chsh -s /bin/bash magento \
    && su magento -c "cd /var/www/dev/magento2 && composer install"

# php RedisAdmin
# https://github.com/erikdubbelboer/phpRedisAdmin
#
RUN su magento -c "cd /var/www/dev && composer create-project -s dev erik-dubbelboer/php-redis-admin /var/www/dev/phpRedisAdmin"

# Magento DEVELOPMENT permissions (this may take a while...)
#
RUN set -x \
    && cd /var/www/dev/magento2 \
    && rm -rf ./generated/metadata/* ./generated/code/* ./pub/static/* ./var/cache/* ./var/page_cache/* ./var/view_preprocessed/* ./var/log/* \
    && find var generated vendor pub/static pub/media app/etc -type f -exec chmod g+w {} \; && find var generated vendor pub/static pub/media app/etc -type d -exec chmod g+ws {} \; && chmod u+x bin/magento

# scripts
#
COPY ./bin/install-magento /usr/local/bin/install-magento
RUN chmod +x /usr/local/bin/install-magento
COPY ./bin/install-sampledata /usr/local/bin/install-sampledata
RUN chmod +x /usr/local/bin/install-sampledata

# configure apache env
#
ENV APACHE_RUN_USER www-data
ENV APACHE_RUN_GROUP www-data
ENV APACHE_LOG_DIR /var/log/apache2
ENV APACHE_PID_FILE /var/run/apache2.pid
ENV APACHE_RUN_DIR /var/run/apache2
ENV APACHE_LOCK_DIR /var/lock/apache2

# cleanup
#
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

WORKDIR /var/www/dev/magento2
