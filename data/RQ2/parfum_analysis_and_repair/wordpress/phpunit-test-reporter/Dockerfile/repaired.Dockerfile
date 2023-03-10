# Start with the latest WordPress image.
FROM wordpress:5.5.1-php7.4

# Set up nodejs PPA
RUN curl -f -sL https://deb.nodesource.com/setup_12.x | bash

# Install server dependencies.
RUN apt-get update && apt-get install -qq -y nodejs build-essential pkg-config libcairo2-dev libjpeg-dev libgif-dev git subversion default-mysql-client zip unzip vim libyaml-dev --fix-missing --no-install-recommends && rm -rf /var/lib/apt/lists/*;

COPY bin/install-wp-tests.sh /
RUN cat /install-wp-tests.sh | bash /dev/stdin wordpress root password mysql latest true

# Setup phpunit dependencies (needed for coverage).
RUN pecl install xdebug && \
		docker-php-ext-enable xdebug

# Download wp-cli
RUN curl -f -o /usr/local/bin/wp https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && chmod 755 /usr/local/bin/wp

# Disable PHP opcache (not great while developing)
RUN rm -rf /usr/local/etc/php/conf.d/opcache-recommended.ini

# Install composer.
RUN curl -f -sS https://getcomposer.org/installer | php -- --install-dir=/usr/bin/ --filename=composer

ENV PATH="/root/.composer/vendor/bin::${PATH}"

RUN composer global require "phpunit/phpunit=5.7.*"
RUN composer global require "dealerdirect/phpcodesniffer-composer-installer"
RUN composer global require wp-coding-standards/wpcs
RUN phpcs --config-set installed_paths /root/.composer/vendor/wp-coding-standards/wpcs
