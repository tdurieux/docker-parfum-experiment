FROM php:8.0-apache

# Apache configuration
RUN a2enmod rewrite

# Install dependencies
RUN apt-get update \
  && apt-get install --no-install-recommends -y zlib1g-dev libicu-dev wget gnupg g++ git openssh-client \
  && apt-get install --no-install-recommends -y libxml2-dev libfreetype6-dev libpng-dev libjpeg-dev libzip-dev \
  && apt-get install --no-install-recommends -y libpng-dev libfreetype6-dev libjpeg62-turbo-dev \
  && apt-get install --no-install-recommends -y libmagickwand-dev unzip \
  && docker-php-ext-configure intl \
  && docker-php-ext-install intl pdo_mysql zip && rm -rf /var/lib/apt/lists/*;

#Install Yarn
RUN curl -f -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
  && echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list

RUN apt-get update \
  && apt-get install --no-install-recommends -y nodejs \
  && apt-get install --no-install-recommends -y yarn && rm -rf /var/lib/apt/lists/*;

# clean
RUN rm -rf /var/cache/apk/*

# Install php extensions.
RUN docker-php-ext-configure gd --with-freetype --with-jpeg
RUN docker-php-ext-install bcmath intl zip pcntl soap gd

# Enable imagick
RUN pecl install imagick && docker-php-ext-enable imagick

# Install xdebug
RUN pecl install xdebug && docker-php-ext-enable xdebug

# Install composer
RUN curl -f -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer
