FROM amazeeio/php:7.3-cli-drupal

# Fix for Drush 9.
RUN /usr/local/bin/composer global remove drush/drush
RUN curl -f -L -o /usr/local/bin/drush "https://github.com/drush-ops/drush-launcher/releases/latest/download/drush.phar" \
    && chmod +x /usr/local/bin/drush

RUN composer self-update --2

COPY composer.json composer.lock /app/
COPY scripts /app/scripts
# Uncomment if you have a patches directory in your Drupal Installation
# COPY patches /app/patches
RUN composer install --prefer-dist --no-dev --no-suggest --optimize-autoloader --apcu-autoloader
COPY . /app

ENV WEBROOT=web
