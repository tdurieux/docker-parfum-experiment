FROM php:5.6-cli

# install composer
RUN curl -f -sS https://getcomposer.org/installer | php
RUN mv composer.phar /usr/local/bin/composer

# Install git
RUN apt-get update && apt-get install --no-install-recommends -y ssh-client zip unzip git && rm -rf /var/lib/apt/lists/*;

# Goto temporary directory.
WORKDIR /tmp

# Run composer and phpunit installation.
RUN composer selfupdate && \
  composer require "phpunit/phpunit:~5.7.27" && \
  ln -s /tmp/vendor/bin/phpunit /usr/local/bin/phpunit

# Set up the application directory.
VOLUME ["/app"]
WORKDIR /app
