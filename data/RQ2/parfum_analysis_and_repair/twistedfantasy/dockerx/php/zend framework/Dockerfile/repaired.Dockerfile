ARG IMAGE
FROM $IMAGE
LABEL maintainer="Denis Sventitsky <denis.sventitsky@gmail.com> / Twisted Fantasy <twisteeed.fantasy@gmail.com>"

RUN apt-get update -y \
    && apt-get install --no-install-recommends -y imagemagick zip unzip && rm -rf /var/lib/apt/lists/*;

# composer
ENV COMPOSER_ALLOW_SUPERUSER=1
RUN curl -f -sS https://getcomposer.org/installer | php
RUN mv composer.phar /usr/local/bin/composer
RUN chmod +x /usr/local/bin/composer

# zend framework
RUN composer require zendframework/zendframework "3.0"
