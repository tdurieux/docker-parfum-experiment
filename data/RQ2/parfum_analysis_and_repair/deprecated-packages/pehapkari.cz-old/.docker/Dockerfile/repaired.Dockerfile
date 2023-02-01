FROM php:7
MAINTAINER adam.stipak@gmail.com

# system deps
RUN apt-get update && \
  apt-get install --no-install-recommends -y \
    git \
    gnupg && rm -rf /var/lib/apt/lists/*;

# system deps configuration
RUN curl -f -sL https://deb.nodesource.com/setup_7.x | bash -

# nodejs
RUN apt-get install --no-install-recommends -y \
    zlib1g-dev \
    nodejs && rm -rf /var/lib/apt/lists/*;

# php extensions
RUN docker-php-ext-install zip

# binaries
RUN curl -f https://getcomposer.org/composer.phar -o "/usr/local/bin/composer" && \
  chmod +x /usr/local/bin/composer

# gulp dependencies
RUN npm install -g \
  gulp \
  gulp-watch && npm cache clean --force;

WORKDIR /src
CMD composer install && \
  npm install && \
  gulp
