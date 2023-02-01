FROM wordpress:php7.3
RUN pecl install xdebug-2.9.8 \
	&& echo 'xdebug.remote_enable=1' >> $PHP_INI_DIR/php.ini \
	&& echo 'xdebug.remote_port=9000' >> $PHP_INI_DIR/php.ini \
	&& echo 'xdebug.remote_host=host.docker.internal' >> $PHP_INI_DIR/php.ini \
	&& echo 'xdebug.remote_autostart=0' >> $PHP_INI_DIR/php.ini \
	&& docker-php-ext-enable xdebug
RUN apt-get update \
	&& apt-get install -y --assume-yes --quiet --no-install-recommends gnupg2 subversion mariadb-client less jq && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y openssh-client && rm -rf /var/lib/apt/lists/*;
RUN curl -f -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
	&& chmod +x wp-cli.phar \
	&& mv wp-cli.phar /usr/local/bin/wp
