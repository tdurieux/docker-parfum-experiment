FROM wordpress:latest

# Install packages
RUN apt-get update && \
    apt-get -y --no-install-recommends install vim subversion default-mysql-client less && rm -rf /var/lib/apt/lists/*;

# Install wp-cli
RUN curl -f -L -s https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar > /usr/local/bin/wp && chmod +x /usr/local/bin/wp

# Add non-privileged user, best for using wp-cli
RUN groupadd -r user && useradd --no-log-init -r -g user user

# Install composer
RUN curl -f https://raw.githubusercontent.com/composer/getcomposer.org/76a7060ccb93902cd7576b67264ad91c8a2700e2/web/installer | php -- --quiet && chmod +x composer.phar && mv composer.phar /usr/local/bin/composer

# Install xdebug
RUN pecl install xdebug
# Copy in our php.ini debug configuration
COPY ./docker-php-ext-xdebug.ini /usr/local/etc/php/conf.d

# Install redis php extension
# The echo is to avoid the terminal prompt on install
RUN echo "\n" | pecl install redis
COPY ./docker-php-ext-redis.ini /usr/local/etc/php/conf.d

COPY ./install-wp-tests-docker.sh /tmp

RUN /tmp/install-wp-tests-docker.sh latest

# Xdebug environment variables
ENV XDEBUG_PORT 9000

# See: https://github.com/docker-library/wordpress/issues/205
COPY ./apache2-custom.sh /usr/local/bin/apache2-custom.sh

COPY ./add-hosts.sh /tmp

CMD ["docker-entrypoint.sh"]
